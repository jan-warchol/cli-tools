#!/bin/bash

# glue repo sequentially from subrepos

mkdir -p gluing
cd gluing
git init

for repo in `ls ../ | grep -v gluing`; do
    git remote add $repo ../$repo
done

git fetch --all