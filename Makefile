
sinclude ../../Makeconf

ifndef MKOCTFILE
	# assumptions to make if not using ./configure script
	MKOCTFILE=mkoctfile
	HAVE_GINAC=1
endif

SRC=symbols.cc ov-ex.cc ov-sym.cc ov-vpa.cc ov-ex-mat.cc probably_prime.cc
OBJ=$(SRC:.cc=.o)

%.o: %.cc ; $(MKOCTFILE) -v $(GINAC_CPP_FLAGS) -c $<

FUNCTIONS=vpa sym is_vpa is_sym is_ex to_double digits\
          Cos Sin Tan aCos aSin aTan Cosh Sinh Tanh aCosh\
          aSinh aTanh Exp Log subs differentiate expand\
          collect coeff lcoeff tcoeff degree ldegree quotient\
          remainder premainder Pi ex_matrix
SYMBOLS_LINKS=$(addsuffix .oct,$(FUNCTIONS))

ifdef HAVE_GINAC
	PROGS=symbols.oct $(SYMBOLS_LINKS)
	GINAC_CPP_FLAGS=$(shell ginac-config --cppflags)
	GINAC_LD_FLAGS=$(shell ginac-config --libs)
else
	PROGS=
endif


all: $(PROGS)

symbols.oct: Makefile $(OBJ)
	$(MKOCTFILE) -v -o $@ $(OBJ) $(GINAC_LD_FLAGS) ; \

$(SYMBOLS_LINKS): Makefile
	-$(RM) $@
	$(LN_S) symbols.oct $@

clean:
	$(RM) *.o *.oct core octave-core *~


