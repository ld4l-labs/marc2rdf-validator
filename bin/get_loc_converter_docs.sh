#!/bin/bash

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    echo "Usage: $0 [output_directory]"
    exit
fi

if [ "$1" != "" ]; then
    dirOption="--directory-prefix=$1"
fi

defaults=" -r --no-parent --level=1"
options="$defaults $dirOption"

wget $options http://www.loc.gov/bibframe/mtbf/

