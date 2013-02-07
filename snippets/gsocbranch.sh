#!/bin/bash

while read branch; do
    echo $branch 
    git checkout --quiet $branch
    git log --oneline gsoc..HEAD; 
    echo " "
done < ../branches
git checkout gsoc

