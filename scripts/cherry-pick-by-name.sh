#!/bin/bash

# this script adds to the current branch all patches about gitingore
# that are present in origin/master
#
# git log ..origin/master = show commits until origin/master (since HEAD)
# --format=%H = show just the committish
# --reverse = oldest commits on top
# --grep "$1" = search in commit messages for what was 
#               specified in script's first argument 
for commit in $(git log ..origin/master --format=%H --reverse --grep "$1"); do
  git cherry-pick $commit
done;


