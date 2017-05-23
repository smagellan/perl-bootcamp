#! /bin/bash

OURS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
echo "using extra dir $OURS_DIR for perl search path";

prove -r -I ${OURS_DIR} unit_tests;
