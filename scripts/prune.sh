#!/bin/bash

IFS=$(echo -en "\n\b")

for file in $(find -type f)
do
    # unless $file is a pdf or midi or zip, delete it
    if [[ $file != *.pdf && $file != *.mid* && $file != *.zip ]]
    then
        mv $file ~/trash/
    fi
done
