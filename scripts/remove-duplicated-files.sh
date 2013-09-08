#!/bin/bash

# this script walks through all subdirectories of current dir,
# compares all files inside (be careful, quadratic computational complexity)
# and moves all duplicates to $dupdir.

IFS=$(echo -en "\n\b")

rundir="$PWD"
rundirname=$(echo $rundir | sed 's|.*/||')
dupdir="$rundir/../duplicates-from-$rundirname/"
mkdir -p $dupdir

for file in $(find -type f); do
    if [ -f "$file" ]; then
        if [ "$1" != "" ]; then
            # echo "====================================="
            echo comparing $file with other files...
        fi

        for anotherfile in $(find -type f); do
            if [ -f "$anotherfile" ] && [ "$anotherfile" != "$file" ]; then
                diff -q "$file" "$anotherfile" 2> /dev/null > /dev/null
                if [[ $? == 0 ]]; then
                    echo "  $anotherfile is a duplicate of $file"
                    mv "$anotherfile" $dupdir
                fi
            fi
        done
    fi
done

