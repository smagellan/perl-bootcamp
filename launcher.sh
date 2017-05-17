#! /bin/bash

OURS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

perl -I $OURS_DIR launcher.pl

#or:
# use FindBin; 
# use lib $FindBin::Bin;
