#!/bin/bash

IFS=$(echo -en "\n\b")

if [ -z $2 ]; then
    echo "Error: too few arguments given."
    echo "\$1 - file with strings to be removed"
    echo "\$2 - file to filter"
    exit 1
fi

while read string; do
    echo removing $string from $2
    grep -v $string "$2" > "$2.temp"
    mv -f "$2.temp" "$2"
done < "$1"