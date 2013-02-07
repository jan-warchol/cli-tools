#!/bin/bash

# this will update all branches in LILYPOND_GIT repository.
# if any argument is specified, it will also delete merged branches
# (i.e. branches that were already pushed upstream or merged with master).

die() { # in case of some error...
    #aplay -q ~/src/sznikers.wav
    echo -e "\e[00;31mSomething went wrong. Exiting.\e[00m"
    exit 1
}

currentbranch=$(git branch --color=never | sed --quiet 's/* \(.*\)/\1/p')

cd $LILYPOND_GIT/
echo "========================================"
echo -e "\e[00;32mFETCHING\e[00m--------------------------------"
git fetch
echo ""

echo -e "\e[00;32mUPDATING YOUR BRANCHES\e[00m------------------";
for branch in $(git branch --color=never | sed s/*//); do
    git checkout --quiet "$branch" || die;
    echo -e "On branch \e[00;33m$branch\e[00m"

    # Try to rebase against respective upstream branch
    # (taken from config). If that fails, try to rebase
    # against origin/master, because that's usually what
    # you want anyway.
    git rebase
    if [ $? != 0 ]; then
        echo -e "\nThis means\e[00;31m a warning: upstream branch is not configured.\e[00m"
        echo "Don't worry, that's not dangerous."
        echo "Trying to rebase on origin/master..."
        sleep 7
        git rebase origin/master || die;
        sleep 3
    fi
    echo "";
done

# $# = number of arguments specified by user
if [ $# != 0 ]; then
    git checkout --quiet master;
    echo -e "\e[00;32mDELETING MERGED BRANCHES\e[00m----------------";
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
