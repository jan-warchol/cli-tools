#!/bin/bash

IFS=$(echo -en "\n\b")

if [ -z $2 ]; then
    echo "Error: too few arguments given."
    echo "\$1 - file listing strings that should be removed"
    echo "\$2 - file to filter through"
    exit 1
fi

while read string; do
    echo removing $string from $2
    grep -v $string "$2" > "$2.temp"
    mv -f "$2.temp" "$2"
done < "$1"