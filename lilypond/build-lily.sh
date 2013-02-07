#!/bin/bash

# Call this script from any directory to compile lilypond.
#
# 1. our assumptions
# 2. gathering information
# 3. preparation
# 4. building.


die() { # in case of some error...
    #aplay -q ~/src/sznikers.wav
    echo -e "\e[00;31mSomething went wrong. Exiting.\e[00m"
    exit 1
}

if [[ "$1" == "help" || "$1" == "-help"
|| "$1" == "--help" || "$1" == "-h"  || "$1" == "h" ]]; then
    echo "\$1 = operating 'mode' (e.g. to make from scratch)"
    echo "\$2 = build directory (default: $LILYPOND_BUILD_DIR)"
    echo "\$3 = commit to build (default: HEAD in $LILYPOND_GIT)"
    exit
fi

echo "========================================"



########################## PREMISES: ###########################
# $LILYPOND_GIT directory exists and it's a LilyPond repository

# note: we use readlink for two reasons:
#  - consistency of the format for the sake of comparisons
#  - some paths may need to be converted to absolute paths

# normalize $LILYPOND_GIT (no / at the end):
LILYPOND_GIT=$(readlink -m $LILYPOND_GIT)
# in case $LILYPOND_BUILD_DIR is unset, set it:
[[ -n "$LILYPOND_BUILD_DIR" ]] || export LILYPOND_BUILD_DIR="$LILYPOND_GIT/build"
# make sure that $LILYPOND_BUILD_DIR directory exists:
mkdir -p $LILYPOND_BUILD_DIR



################### GATHERING INFORMATION: #####################
# determine build directory (based on second argument):
#  - if an absolute path is specified, use it.
#  - if a relative path is specified, it is taken relative
#    to the $LILYPOND_BUILD_DIR. So, if 2nd argument is empty
#    $LILYPOND_BUILD_DIR is used.

cd $LILYPOND_BUILD_DIR
if [ "$2" != "" ]; then
    mkdir -p $2
    cd $2
fi
build=$(pwd)

# check what is the relation between build dir
# and main lilypond repository ($LILYPOND_GIT).

if [[ $build == $LILYPOND_GIT/* ]]; then
    building_inside_main_repo="yes"
    source=$LILYPOND_GIT
else
    building_inside_main_repo="no"
    source=$build # (source code will be copied to $build)
fi

# what we know at this moment:
#  - $source is an absolute path to the repository
#    from which we're building,
#  - $build is an absolute path to the directory
#    where we'll be building,
#  - $build exists (but it may be empty).



######################## PREPARATION: ##########################

# if we're building directly in $LILYPOND_GIT, we don't want
# to make from scratch (e.g. erase everything before building)
# because that'd delete the repository and all of user's work.
cd $build
if [[ "$1" == s* && "$build" != "$LILYPOND_GIT" ]]; then
    echo "You requested to build from scratch."
    echo "Removing $build directory..."
    # give the user 5 seconds to abort the script
    # (using ctrl-C) if something is wrong.
    # Pressing return skips this delay.
    read -t 5 confirmation
    cd ../
    rm -r $HOME/.local/share/Trash/$(basename $build) 2> /dev/null
    mv $build $HOME/.local/share/Trash/
    mkdir -p $build
fi

# Does $source contain lilypond source code, or is it empty?
# We check this by asking git if $source is a repository at all.
# We discard actual error message produced by rev-parse.
cd $source
git rev-parse 2> /dev/null
if [ $? != 0 ]; then
    # non-zero exit status of rev-parse means that this directory
    # (i.e. $source) isn't inside a repository.
    # (This means we must be building outside $LILYPOND_GIT,
    # which in turn means that $source=$build.)
    # 
    # One thing we should check: maybe $build is a directory
    # containing *subdirectories* with lilypond builds?
    # (this would probably mean that the user made a mistake
    # and actually intended to specify a subdir of $build).
    # If that's the case, ask the user.
    #
    # If that's not the case, we simply are in a freshly created dir,
    # and we have to clone $LILYPOND_GIT to get the sources.
    #
    notArepo=1
    for subdir in $(find . -mindepth 1 -maxdepth 1 -type d); do
        cd $subdir
        git rev-parse 2> /dev/null
        notArepo=$[notArepo*$?] 
        cd ../
    done
    if [ $notArepo == 0 ]; then
        echo "You told me to build lilypond inside $build."
        echo "But it already contains *subdirectories* with some repositories."
        echo "Are you sure that you want to overwrite them [y/n]?"
        read decision
        if [ "$decision" != "y" ]; then die; fi
    fi
    # proceed -> clone fresh sources
    cd ../
    git clone $LILYPOND_GIT $source
    cd $source
else 
    # we have lily source code, but it may need updating
    # (if it's a local clone of LILYPOND_GIT)
    if [[ "$building_inside_main_repo" == "no" ]]; then
        git fetch
    fi
fi

# find the ID of the commit we want to compile.
# if it wasnt specified by user, grab HEAD of LILYPOND_GIT
if [ "$3" != "" ]; then
    cd $source
    git checkout --quiet $3
    || echo "I cannot checkout $3. Maybe it is a detached HEAD?"
    && echo "Having this commit as an explicit branch might help." && die;
else
    cd $LILYPOND_GIT
fi
commit=$(git rev-parse HEAD)
cd $source
git checkout --quiet $commit
|| echo "I cannot checkout $commit. Maybe it is a detached HEAD?"
&& echo "Having this commit as an explicit branch might help." && die;



######################### BUILDING: ############################

# we should be inside $source now.
echo -e "Attempting to build lilypond: \n"
git log -n 1
echo ""
echo -e "inside directory \n  $build \n"
# give the user 8 seconds to check above information.
read -t 8 confirmation

# build dir might have been freshly created, so we need
# to check whether it contains necessary setup information.
cd $build
if [ "$(grep -s configure-srcdir config.make \
                     | sed s/configure-srcdir\ =\ //)" == "" ]; then
    # make doesn't know where the sources to build from
    # are located. Need to run autogen and configure
    cd $source; ./autogen.sh --noconfigure
    echo ""
    cd $build; $source/configure || die
fi

# actual compiling. $multimake is defined as make with options.
echo "----------------------------------------"
if [[ "$1" == b* ]]; then
    time $multimake bin || die
else
    time $multimake || die
fi

if [ $? == 0 ]; then
    # last command (make) exited with 0, so build was sucessful.
    echo "----------------------------------------"
    cd $source
    echo -e "successfully built lilypond: \n"
    git log -n 1
    echo ""
    echo -e "inside directory \n  $build"
fi

echo "________________________________________"

