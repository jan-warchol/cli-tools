#!/bin/bash

# Call this script from any directory to compile lilypond.
#
# 1. our assumptions
# 2. gathering information
# 3. preparation
# 4. building.

# amount of time that we give to the user to check
# information at various moments (default value, in seconds)
timeout=10

while getopts "bc:d:hst:" opts; do
    case $opts in
    b)
        only_bin="yes";;
    c)
        whichcommit=$OPTARG;;
    d)
        whichdir=$OPTARG;;
    h)
        help="yes";;
    s)
        from_scratch="yes";;
    t)
        timeout=$OPTARG;;
    esac
done

die() {
    # in case of some error...
    echo -e "\e[00;31mSomething went wrong. Exiting.\e[00m"
    exit 1
}

if [[ "$help" == "yes" ]]; then
    echo "read the comments in the script to understand it, hoho!"
    exit
fi

echo "========================================"



########################## PREMISES: ###########################
# $LILYPOND_GIT directory should exist and be a LilyPond repository
if [ -z $LILYPOND_GIT ]; then
    echo '$LILYPOND_GIT environment variable is unset.'
    echo "Please set it to point to the location of LilyPond source repository."
    die
fi

# note: we use readlink for two reasons:
#  - consistency of the format for the sake of comparisons
#  - some paths may need to be converted to absolute paths

# normalize $LILYPOND_GIT (no / at the end):
LILYPOND_GIT=$(readlink -m $LILYPOND_GIT)
# in case $LILYPOND_BUILD_DIR is unset, set it:
if [ -z "$LILYPOND_BUILD_DIR" ]; then
    echo '$LILYPOND_BUILD_DIR variable is unset.'
    echo 'Setting it to be a build/ subdir of $LILYPOND_GIT'
    export LILYPOND_BUILD_DIR="$LILYPOND_GIT/build"
fi
# make sure that $LILYPOND_BUILD_DIR directory exists:
mkdir -p $LILYPOND_BUILD_DIR



################### GATHERING INFORMATION: #####################
# determine build directory (based on the value of -d option):
#  - if an absolute path is specified, use it.
#  - if a relative path is specified, it is taken relative
#    to the $LILYPOND_BUILD_DIR.

cd $LILYPOND_BUILD_DIR
if [ "$whichdir" != "" ]; then
    mkdir -p $whichdir
    cd $whichdir
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
if [[ "$from_scratch" == "yes" && "$build" != "$LILYPOND_GIT" ]]; then
    echo "You requested to build from scratch."
    echo -e "Removing \e[00;33m$build\e[00m directory in $timeout seconds"
    echo "(press Ctrl-C to abort, Enter to skip delay)"
    read -t $timeout confirmation
    cd ../
    rm -rf $build
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
fi

# The value of -c option specifies what to build.
# It can be a commit (specified using a committish, a branch name,
# a tag, etc.) or the current state of working directory at
# $LILYPOND_GIT (if no value was specified).  The latter case
# means that we have to create a temporarty commit containing
# this state, so that it can be passed to the "satellite" repository
# (if any exists).  In any case, the commit to be built is passed
# using a special tag; since tags won't be automatically force-updated,
# old tags have to be deleted first.

git tag -d commit_to_build > /dev/null 2> /dev/null
cd $LILYPOND_GIT
git tag -d commit_to_build > /dev/null 2> /dev/null

if [ "$whichcommit" != "" ]; then
    git tag commit_to_build $whichcommit
else
    # prepare a description for the temporary commit
    if (( $(git diff --color=never HEAD | wc --chars) < 5000 ))
    then
        description=$(echo -e \
        "\nChanges:\n\n$(git diff HEAD)")
    else
        description=$(echo -e \
        "\nSummary of changes:\n\n$(git diff --stat HEAD)")
    fi

    git commit --quiet -a -m \
    "A temporary commit - work in progress to be compiled.$description"
    if [ $? != 0 ]; then
        # there was actually nothing to commit
        git tag commit_to_build
    else
        echo "Creating a temporary commit..."
        git tag commit_to_build
        # restore previous (uncommitted) state
        git reset --quiet HEAD~1
    fi
fi

cd $source
if [[ "$building_inside_main_repo" == "no" ]]; then
    git fetch --quiet --tags
fi
git checkout --quiet commit_to_build
if [ $? != 0 ]; then
    echo "I cannot checkout commit_to_build."
    echo "Having this commit as an explicit branch might help."
    die
fi


######################### BUILDING: ############################

# we should be inside $source now.
echo -e "Attempting to build lilypond: \n"
git log -n 1 | cat
echo ""
echo -e "inside directory \n  \e[00;33m$build\e[00m"
echo -e "in $timeout seconds (press Ctrl-C to abort, Enter to skip delay)\n"
read -t $timeout confirmation

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

# actual compiling.
echo "----------------------------------------"
if [[ "$only_bin" == "yes" ]]; then
    time make $MAKE_OPTIONS bin || die
else
    time make $MAKE_OPTIONS || die
fi

if [ $? == 0 ]; then
    # last command (make) exited with 0, so build was sucessful.
    echo "----------------------------------------"
    cd $source
    echo -e "successfully built lilypond: \n"
    git log -n 1 | cat
    echo ""
    echo -e "inside directory \n  $build"
fi

echo "________________________________________"

