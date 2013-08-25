#!/bin/bash

if [ -z $1 ]; then
    echo "Too few arguments."
    echo "Please specify whether you want to prune (p)"
    echo "or keep (k) some files from your repository."
    exit 1
fi

if [ ! -f ~/file-list.txt ]; then
    echo "Error."
    echo "Please put the list of the files you want"
    echo "to prune/keep in ~/file-list.txt."
    exit 1
fi

if [ "$1" == "p" ]; then
    git filter-branch --prune-empty --index-filter \
    '$MY_SCRIPTS/git-prune-files.sh ~/file-list.txt' \
    -- --all
fi

if [ "$1" == "k" ]; then
    git filter-branch --prune-empty --index-filter \
    '$MY_SCRIPTS/git-keep-files.sh ~/file-list.txt' \
    -- --all
fi