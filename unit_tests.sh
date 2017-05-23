#! /bin/bash

OURS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
echo "using extra dir $OURS_DIR for perl search path";

find unit_tests/ -type f -name '*.t' | xargs -n1 perl -I ${OURS_DIR} 

#TODO: add compile_all_PARALLEL.t/ -cw "-MO=Lint,no-context" check

#to get rid of -I key:
# use FindBin; 
# use lib $FindBin::Bin;
