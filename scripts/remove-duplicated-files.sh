#!/bin/bash

# this script walks through all subdirectories of current dir,
# compares all files inside (be careful, quadratic computational complexity)
# and moves all duplicates to $dupdir.

IFS=$(echo -en "\n\b")

dupdir="$HOME/duplicates/"
mkdir -p $dupdir
rundir="$PWD"

for file in $(find -type f); do
    if [ -f "$file" ]; then
        echo "====================================="
        echo comparing $file with other files...

        for anotherfile in $(find -type f); do
            if [ -f "$anotherfile" ] && [ "$anotherfile" != "$file" ]; then
                diff -q "$file" "$anotherfile" 2> /dev/null > /dev/null
                if [[ $? == 0 ]]; then
                    echo $anotherfile is a duplicate of $file. Moving...
                    mv "$anotherfile" $dupdir
                fi
            fi
        done
    fi
done

