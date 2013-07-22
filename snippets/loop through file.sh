#!/bin/bash

# loop through 'somefile' reading it line-by-line:
while read line; do 
    echo $line 
    # do something...
done < ../somefile

