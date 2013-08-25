#!/bin/bash

if [ -z "$1" ]; then
    echo "Too few arguments - you didn't tell filter-branch what to do."
    exit 1
fi

git filter-branch -f --prune-empty --tree-filter \
"$1" \
-- --all