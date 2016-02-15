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
%% @deftypefn  {Function File}  {@var{z} =} times (@var{x}, @var{y})
%% Return elementwise multiplication of two syms (dot star).
%%
%% @end deftypefn

%% Author: Colin B. Macdonald
%% Keywords: symbolic

function z = times(x, y)

  % Dear hacker from the distant future... maybe you can delete this?
  if (isa(x, 'symfun') || isa(y, 'symfun'))
    warning('OctSymPy:sym:arithmetic:workaround42735', ...
            'worked around octave bug #42735')
    z = times(x, y);
    return
  end


  cmd = { '(x,y) = _ins'
          'if isinstance(x, sp.MatrixBase) and isinstance(y, sp.MatrixBase):'
          '    return x.multiply_elementwise(y),'
          'return x*y,' };

  z = python_cmd (cmd, sym(x), sym(y));

end


%!test
%! % scalar
%! syms x
%! assert (isa (x.*2, 'sym'))
%! assert (isequal (x.*2, x*2))
%! assert (isequal (2.*sym(3), sym(6)))
%! assert (isequal (sym(2).*3, sym(6)))

%!test
%! % matrix-matrix and matrix-scalar
%! D = [0 1; 2 3];
%! A = sym(D);
%! assert (isequal ( 2.*A , 2*D  ))
%! assert (isequal ( A.*2 , 2*D  ))
%! assert (isequal ( A.*A , D.*D  ))
%! assert (isequal ( A.*D , D.*D  ))
%! assert (isequal ( D.*A , D.*D  ))
