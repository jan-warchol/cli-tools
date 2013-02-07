#!/bin/bash

# this script walks through all subdirectories of current dir,
# compares all files inside (be careful, quadratic computational complexity)
# and moves all duplicates to $dupdir.

IFS=$(echo -en "\n\b")

dupdir="~/duplicates/"
rundir="$PWD"

for dir in $(find * -type d)
do
    cd "$rundir/$dir"

    for file in *; do
        if [ -f "$file" ]; then
            echo $file

            for anotherfile in *; do
                if [ -f "$anotherfile" ] && [ "$anotherfile" != "$file" ]; then
                    diff -q "$file" "$anotherfile" 2> /dev/null > /dev/null
                    if [[ $? == 0 ]]; then
                        mv "$anotherfile" $dupdir
                    fi
                fi
            done
        fi
    done
done

