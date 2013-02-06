#!/bin/bash

die() {
    aplay -q ~/src/sznikers.wav
    exit 1
}

cd $LILYPOND_GIT/
echo "========================================"
echo "FETCHING--------------------------------"
git fetch
echo ""

echo "UPDATING BRANCHES-----------------------";
for branch in $(git branch | sed s/*//); do 
    git checkout --quiet "$branch"; 
    #rebases on respective remote tracking branch (taken from config)
    git rebase || die;
    echo "";
done

git checkout --quiet master;

if [ $# == 0 ]; then
    echo "DELETING MERGED BRANCHES----------------";
    for branch in $(git branch| sed s/*// | sed s/master//); do 
        git branch -d "$branch"
        echo ""
    done
    echo ""
fi

echo "UPDATING MIRROR REPOSITORY--------------"
cd $LILYPOND_GIT/../mirror-repo
for branch in $(git branch | sed s/*//); do 
    git checkout --quiet "$branch"; 
    #rebases on respective remote tracking branch (taken from config)
    git rebase || die;
done
echo "________________________________________"
echo ""

#aplay -q ~/src/sznikers.wav
