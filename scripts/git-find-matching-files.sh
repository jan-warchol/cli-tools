#!/bin/bash

IFS=$(echo -en "\n\b")

if [ -z $1 ]; then
    echo "Error: no pattern given"
    exit 1
fi

# search for files containing $pattern and save
# a list of them in a file.
git grep --color=never $1 | sed s/:.*// > matching-files.txt