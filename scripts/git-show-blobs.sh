#!/bin/bash

# from http://stackoverflow.com/a/5293344/2058424

git rev-list --objects --all |
    while read sha1 fname
    do 
        echo -e "$(git cat-file -s $sha1)\t$\t$fname"
    done | sort -n
