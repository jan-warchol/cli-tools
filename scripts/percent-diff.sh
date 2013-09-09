#!/bin/bash

fileA="pies(2009-10-09).txt"
fileB="pies(2009-10-09) (copy).txt"

A_len=$(cat "$fileA" | wc -l)
B_len=$(cat "$fileB" | wc -l)
if [[ $A_len>$B_len ]]; then
    bigger=$fileA
    smaller=$fileB
    max_len=$A_len
    min_len=$B_len
else
    bigger=$fileB
    smaller=$fileA
    max_len=$B_len
    min_len=$A_len
fi

differences=$(sdiff -B -s "$fileA" "$fileB" | wc -l)
common=$(expr $max_len - $differences)

percentage=$(echo "100 * $common / $min_len" | bc)
echo "$percentage% of file $smaller is the same as in $bigger"
