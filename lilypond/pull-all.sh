#!/bin/bash

die() {
    aplay -q ~/src/sznikers.wav
    exit 1
}

currentbranch=$(git branch --color=never | sed --quiet 's/* \(.*\)/\1/p')

cd $LILYPOND_GIT/
echo "========================================"
echo "FETCHING--------------------------------"
git fetch
echo ""

echo "UPDATING BRANCHES-----------------------";
for branch in $(git branch --color=never | sed s/*//); do
    git checkout --quiet "$branch" || die;
    #rebases on respective remote tracking branch (taken from config)
    git rebase || die;
    echo "";
done

if [ $# == 0 ]; then
    git checkout --quiet master;
    echo "DELETING MERGED BRANCHES----------------";
    for branch in $(git branch --color=never | sed s/*// | sed s/master//); do
        git branch -d "$branch"
        echo ""
    done
    echo ""
fi

git checkout $currentbranch

echo "________________________________________"
echo ""

#aplay -q ~/src/sznikers.wav
