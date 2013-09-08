#!/bin/bash

# this script walks through all subdirectories of current dir,
# compares all files inside (be careful, quadratic computational complexity)
# and moves all duplicates to $dupdir.

# since this is quadratic, you are advised to divide your files
# to subdirectories containing files with the same size
# (as differently sized files cannot be duplicates).
# this should speed up everything enormously.

# TODO:
# don't deduplicate empty files
# check if one filename is a substring of another
# (so that in case of foo.txt and foo(copy).txt
# the script will remove foo(copy).txt )

IFS=$(echo -en "\n\b")

rundir="$PWD"
rundirname=$(echo $rundir | sed 's|.*/||')
dupdir="$rundir/../duplicates-from-$rundirname/"
mkdir -p $dupdir

for dir in $(find * -type d)
do
    cd "$rundir/$dir"
    echo Directory $dir: $(find -type f | wc -l) files to compare.

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
done

