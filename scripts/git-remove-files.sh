#!/bin/bash

# usage:
# git filter-branch --prune-empty --index-filter \
# 'this-script list-of-files-to-be-kept' -- --all

if [ -z $1 ]; then
    echo "Too few arguments."
    echo "Please specify an absolute path to the file"
    echo "which contains the list of files that should"
    echo "remain in the repository after filtering."
    exit 1
fi

# save a list of files present in the commit
# which is currently being modified.
git ls-tree -r --name-only --full-tree $GIT_COMMIT > files.txt

# delete all files that shouldn't be removed from above list
while read string; do
    grep -v "$string" files.txt > files.txt.temp
    mv -f files.txt.temp files.txt
done < $1

# remove unwanted files (i.e. all that remained in the list).
# warning: 'git rm' will exit with non-zero status if it gets
# an invalid (non-existent) filename OR if it gets no arguments.
# That's why we have to check carefully what is passed to it.
if [ "$(cat files.txt)" != "" ]; then
    cat files.txt | \
    # enclose filenames in "" in case they contain spaces
    sed -e 's/^/"/g' -e 's/$/"/g' | \
    xargs git rm --cached --quiet
fi
