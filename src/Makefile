# OctSymPy does need an Makefile for "pkg install octsympy".

# We have this Makefile mainly for post-processing the code to make a
# package for Matlab.  Also, for legacy reasons, the Makefile can
# regenerate the autogenerated .m files.

OCTAVE ?= octave
PYTHON ?= python

default:
	echo "no installation steps are needed"

matlab: ml_copy ml_convert ml_extract_tests

clean: matlab_clean

#######################################################

codegen:
	${PYTHON} generate_functions.py install

codegen_clean:
	${PYTHON} generate_functions.py clean

ml_extract_tests: ml_copy
	mkdir -p ../matlab/tests_matlab/
	cp -ra ../extract_tests_for_matlab.m ../matlab/
	cp -ra ../octsympy_tests_matlab.m ../matlab/
	cd ../matlab/; ${OCTAVE} -q --eval "extract_tests_for_matlab"
	rm -f ../matlab/extract_tests_for_matlab.m

ml_copy: ml_convert
	cp -ra ../inst/private ../matlab/
	mv ../matlab/private/my_print_usage.m ../matlab/private/print_usage.m
	cp -ra ../inst/@sym/private ../matlab/@sym/
	cp -ra ../inst/@symfun/private ../matlab/@symfun/
	cp -ra ../matlab/private/print_usage.m ../matlab/@sym/private/
	cp -ra ../matlab/private/print_usage.m ../matlab/@symfun/private/
	cp -af ../CONTRIBUTORS ../matlab/
	cp -af ../NEWS ../matlab/
	cp -af ../COPYING ../matlab/
	cp -af ../matlab_smt_differences.md ../matlab/
	cp -af ../README.md ../matlab/
	cp -af ../README.matlab.md ../matlab/
	rm -f ../matlab/octsympy_tests.m

ml_convert:
	mkdir -p ../matlab/@sym/
	mkdir -p ../matlab/@symfun/
	mkdir -p ../matlab/@logical/
	cp -ra ../convert_comments.m ../matlab/
	cd ../matlab/; ${OCTAVE} -q --eval "convert_comments('../inst/', '',         '../matlab/')"
	cd ../matlab/; ${OCTAVE} -q --eval "convert_comments('../inst/', '@symfun',  '../matlab/')"
	cd ../matlab/; ${OCTAVE} -q --eval "convert_comments('../inst/', '@sym',     '../matlab/')"
	cd ../matlab/; ${OCTAVE} -q --eval "convert_comments('../inst/', '@logical', '../matlab/')"
	rm -f ../matlab/convert_comments.m

matlab_clean:
	rm -f ../matlab/*.m
	rm -f ../matlab/CONTRIBUTORS
	rm -f ../matlab/COPYING
	rm -f ../matlab/NEWS
	rm -f ../matlab/*.md
	rm -rf ../matlab/@sym
	rm -rf ../matlab/@symfun
	rm -rf ../matlab/@logical
	rm -rf ../matlab/private
	rm -rf ../matlab/tests_matlab

distclean:
	rm -f configure config.log aclocal.m4
	rm -rf autom4te.cache
