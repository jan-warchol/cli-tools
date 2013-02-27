#!/bin/bash

# this script moves all files which names end with ~ to trash.

IFS=$(echo -en "\n\b")

cd $HOME
for file in $(find -name "*~")
do
    if [[ "$file" != *".local/share/Trash"* ]]; then
        echo $file | tee -a ~/.deleted-tildes.log 
        mv $file ~/.local/share/Trash/
    fi        
done

