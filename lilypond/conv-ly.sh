#!/bin/bash
# use convert-ly accompanying lily version marked as "default"
# $1 - optional arguments to convert-ly

for file in $(find ./ -name "*ly"); do
    $parentlilybins/$defaultlily/out/bin/convert-ly -e $1 $file
done
