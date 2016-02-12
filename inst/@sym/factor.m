%% Copyright (C) 2014, 2016 Colin B. Macdonald
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @documentencoding UTF-8
%% @deftypefn  {Function File}  {@var{e} =} factor (@var{n})
%% @deftypefnx {Function File}  {[@var{p}, @var{m}] =} factor (@var{n})
%% @deftypefnx {Function File}  {@var{g} =} factor (@var{f})
%% @deftypefnx {Function File}  {@var{g} =} factor (@var{f}, @var{x})
%% @deftypefnx {Function File}  {@var{g} =} factor (@var{f}, @var{x}, @var{y}, @dots{})
%% Factor a symbolic polynomial or integer.
%%
%% A symbolic integer @var{n} can be factored:
%% @example
%% @group
%% e = factor(sym(28152))
%%   @result{} e = (sym)
%%         1  3   1  2
%%       17 ⋅2 ⋅23 ⋅3
%% @end group
%% @end example
%%
%% However, if you want to do anything other than just look at the result,
%% you probably want:
%% @example
%% @group
%% [p, m] = factor(sym(28152))
%%   @result{} p = (sym) [2  3  17  23]  (1×4 matrix)
%%   @result{} m = (sym) [3  2  1  1]  (1×4 matrix)
%% prod(p.^m)
%%   @result{} (sym) 28152
%% @end group
%% @end example
%%
%% An example of factoring a polynomial:
%% @example
%% @group
%% syms x
%% factor(x**2 + 7*x + 12)
%%   @result{} (sym) (x + 3)⋅(x + 4)
%% @end group
%% @end example
%%
%% When the expression @var{f} depends on multiple variables,
%% the second argument @var{x} effects what is factored:
%% @example
%% @group
%% syms x y
%% f = expand((x+3)*(x+4)*(y+5)*(y+6));
%% factor(f)
%%   @result{} (sym) (x + 3)⋅(x + 4)⋅(y + 5)⋅(y + 6)
%% factor(f, x, y)
%%   @result{} (sym) (x + 3)⋅(x + 4)⋅(y + 5)⋅(y + 6)
%% factor(f, x)
%%   @result{} (sym)
%%                       ⎛ 2            ⎞
%%       (x + 3)⋅(x + 4)⋅⎝y  + 11⋅y + 30⎠
%% factor(f, y)
%%   @result{} (sym)
%%                       ⎛ 2           ⎞
%%       (y + 5)⋅(y + 6)⋅⎝x  + 7⋅x + 12⎠
%% @end group
%% @end example
%%
%% @seealso{expand}
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function [p, m] = factor(f, varargin)

  if (isempty (findsymbols (f)))
    %% no symbols: we are doing integer factorization

    if (nargin ~= 1)
      print_usage ();
    end

    if (nargout <= 1)
      if (~isscalar(f))
        error('FIXME: check SMT, allows array input here?')
      end
      % this is rather fragile, as noted in docs
      p = python_cmd ('return factorint(_ins[0], visual=True),', f);
    else
      if (~isscalar(f))
        error('vector output factorization only for scalar integers')
      end
      cmd = { 'd = factorint(_ins[0], visual=False)'
              'num = len(d.keys())'
              'sk = sorted(d.keys())'
              'p = sp.Matrix(1, num, sk)'
              'm = sp.Matrix(1, num, lambda i,j: d[sk[j]])'
              'return (p, m)' };
      [p, m] = python_cmd (cmd, f);
    end


  else
    %% have symbols: do polynomial factorization

    if (nargout > 1)
      print_usage ();
    end

    cmd = { 'p = factor(*_ins)'
            'return p,' };
    p = python_cmd (cmd, sym(f), varargin{:});
  end
end



%!test
%! % n = 152862;
%! % [p,m] = factor(n);  % only works on Octave, no Matlab as of 2014a
%! n = 330;  % so we use an output without repeated factors
%! p = factor(n); m = ones(size(p));
%! [ps,ms] = factor(sym(n));
%! assert (isequal (p, ps))
%! assert (isequal (m, ms))

%!test
%! n = sym(2)^4*13;
%! [p,m] = factor(n);
%! assert (isequal (p, [2 13]))
%! assert (isequal (m, [4 1]))

%!test syms x
%! assert( logical (factor(x^2 + 6*x + 5) == (x+5)*(x+1)))

%!test
%! syms x
%! f = [ x^4/2 + 5*x^3/12 - x^2/3     x^2 - 1      10];
%! g = [ x^2*(2*x - 1)*(3*x + 4)/12   (x+1)*(x-1)  10];
%! assert (isequal (factor(f), g))

%!test
%! % "fragile form" works
%! A = factor(sym(124));
%! B = strtrim(disp(A, 'flat'));
%! assert (strcmp (B, '2**2*31**1'))

%!error [p, m] = factor(sym('x'));
%!error [p, m] = factor(sym(42), sym('x'));
