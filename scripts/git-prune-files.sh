#!/bin/bash

if [ -z $1 ]; then
    echo "Too few arguments."
    echo "Please specify an absolute path to the file"
    echo "which contains the list of files that should"
    echo "remain in the repository after filtering."
    exit 1
fi

IFS=$(echo -en "\n\b")

while read filename; do
    # enclose filenames in "" in case they contain spaces
    echo $filename | sed -e 's/^/"/g' -e 's/$/"/g' | \
    xargs git rm -r --cached --ignore-unmatch --quiet
done < $1