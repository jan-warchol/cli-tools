#!/bin/bash

# rip subdirectories and files from repository using filter-branch 

base_branch="master"

for elem in `git ls-tree --name-only --full-tree HEAD`; do
    echo -e "\nProcessing $elem..."
    sanitized_elem=`echo $elem | sed -e s/[^A-Za-z0-9.,_\(\)\-]/_/g`
    
    if [ -d $elem ]; then
        git filter-branch -f --subdirectory-filter $elem -- $base_branch
       # git filter-branch -f --tree-filter 'mkdir -p fooflak/; git mv `ls | grep -v fooflak` fooflak/' -- $base_branch
        git branch "filtered-$sanitized_elem"
        git reset --hard refs/original/refs/heads/$base_branch
    fi
    
    if [ -f $elem ]; then
        git filter-branch -f --prune-empty --index-filter \
            "~/repos/cli-tools/scripts/git-remove-all-files-except-given.sh $elem" -- $base_branch
        git branch "filtered-$sanitized_elem"
        git reset --hard refs/original/refs/heads/$base_branch
    fi
done

for branch in $(git branch --color=never | sed s/*// | grep "filtered-" ); do
    git clone -b $branch --single-branch ./ "`pwd`-filtered/`echo $branch | sed -e s/filtered-//`"
done
