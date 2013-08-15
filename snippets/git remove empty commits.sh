#!/bin/bash

# taken from http://stackoverflow.com/a/5324916/2058424
# this removes all empty commits (including merges)
# from all branches

git filter-branch --commit-filter 'git_commit_non_empty_tree "$@"' -- --all