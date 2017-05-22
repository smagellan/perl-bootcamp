#! /bin/bash

OURS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
echo "using extra dir $OURS_DIR for perl search path";

perl -I ${OURS_DIR} unit_tests/tasks/TaskQueryProvider_sanity_checker.t

#TODO: add compile_all_PARALLEL.t/ -cw "-MO=Lint,no-context" check

#to get rid of -I key:
# use FindBin; 
# use lib $FindBin::Bin;
