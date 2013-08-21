#!/bin/bash

# written by Janek Warchoł (janek.lilypond@gmail.com)

helpmessage="This script will build LilyPond for you.

You should have a git repository with LilyPond source code,
and an environment variable \$LILYPOND_GIT pointing there.

Usage: with no options specified, lilypond will be built in
\$LILYPOND_BUILD_DIR/current, using the current state of the
working directory in \$LILYPOND_GIT repository.

-s option means to \"build from scratch\", i.e. delete previous
   build results before compiling again.

-b option tells make just to compile C++ files, without walking
   through all other files.  If this is all you need, it is the
   fastest solution.

-t <value> sets the amount of time for which the script is paused
   when the user has to check whether the setup is correct.

-h displays this help.

-c <commit> tells the script to compile a particular commit
   instead of current working directory state. This can be
   a SHA1 commit ID, branch name or a tag name. This value
   will also be used as the name of the build subdirectory,
   unless overridden with a -d option.

-d <path> is the directory where the build will happen.
   This can be an absolute path or a path relative to
   \$LILYPOND_BUILD_DIR.

-l build in the current directory.

-r compile regression tests.

-f <path> take sources from this directory, not \$LILYPOND_GIT.

Sometimes it is useful to have multiple LilyPond builds,
or to be able to continue changing source code while the
previous state is being compiled.  You can do this quite
easily - set your \$LILYPOND_BUILD_DIR to a directory outside
of \$LILYPOND_GIT, and compile lilypond in its subdirectories
(using the -d option of this script).

In such situations (i.e. when the build directory isn't inside
main repository) the script will clone lilypond repository into
that build directory, so that it will be completely separate
from your main repository.  This way you can continue your work,
switch branches etc. without affecting the code that is being
compiled at the moment.

Note that these \"satellite build repositories\" work just as
\"regular builds\" inside \$LILYPOND_GIT - you don't have to
commit your work to build it, and if you make changes, you can
rebuild them in the same satellite repo without having to copy
things around or rebuilding from scratch.  The script handles
all this quite fine.

This script can be called from any directory whatsoever.

Example usage:
path-to-this-script -d mybuildname -c master
will compile master branch in \$LILYPOND_BUILD_DIR/mybuildname

Press q to close this help message.
"

# TODO:
# add a switch to disable colors
# support untracked files with satellite repositories
# allow to specify processor threads? or better,
# detect automatically
# grep -c ^processor /proc/cpuinfo
# with an option to override it, ofc.

if [[ "$1" == "help" || "$1" == "--help" ]]; then
    help="yes"
fi

while getopts "bc:d:f:hlrst:" opts; do
    case $opts in
    b)
        only_bin="yes";;
    c)
        whichcommit=$OPTARG
        whichdir=$OPTARG
        ;;
    d)
        whichdir=$OPTARG;;
    f)
        main_repository=$OPTARG;;
    h)
        help="yes";;
    l)
        whichdir=$(pwd);;
    r)
        regtests="yes";;
    s)
        from_scratch="yes";;
    t)
        timeout=$OPTARG;;
    esac
done

if [[ "$help" == "yes" ]]; then
    echo -en "$helpmessage" | less
    exit
fi

# If not specified otherwise, LilyPond sources
# are taken from $LILYPOND_GIT
if [ -z $main_repository ]; then
    main_repository=$LILYPOND_GIT
fi

# default build subdirectory
if [ -z $whichdir ]; then
    whichdir="current"
fi

# amount of time that we give to the user to check
# information at various moments (default value, in seconds)
if [ -z $timeout ]; then
    timeout=10
fi

# some colors
violet="\e[00;35m"
yellow="\e[00;33m"
green="\e[00;32m"
red="\e[00;31m"
normal="\e[00m"
dircolor=$violet

die() {
    # in case of some error...
    echo -e "$red$1$normal"
    echo Exiting.
    if [ "$dirtytree" != "" ]; then
        echo -e "$red""Warning!
        When this script was ran, the HEAD of $source
        repository was $prev_commit
        (branch $prev_branch)
        and there were uncommitted changes on top of that commit.
        They were saved using 'git stash' and you should be able
        to get them back using 'git stash apply'."
    fi
    exit 1
}



########################## PREMISES: ###########################
# $LILYPOND_GIT directory should exist and be a LilyPond repository
if [ -z "$main_repository" ]; then
    echo -e "$red\$LILYPOND_GIT environment variable is unset."
    echo -e "$normal""Please set it to point to the" \
            "LilyPond git repository."
    exit 1
fi

# note: we use readlink for two reasons:
#  - consistency of the format for the sake of comparisons
#  - some paths may need to be converted to absolute paths

# normalize $main_repository (no / at the end):
main_repository=$(readlink -m $main_repository)
# in case $LILYPOND_BUILD_DIR is unset, set it:
if [ -z "$LILYPOND_BUILD_DIR" ]; then
    echo '$LILYPOND_BUILD_DIR variable is unset.'
    echo "Setting it to $main_repository/build."
    export LILYPOND_BUILD_DIR="$main_repository/build"
    read -t 5 proceed
fi
# make sure that $LILYPOND_BUILD_DIR directory exists:
mkdir -p $LILYPOND_BUILD_DIR

# assert $MAKE_OPTIONS for optimum performance
if [ -z "$MAKE_OPTIONS" ]; then
    echo -e "$yellow\$MAKE_OPTIONS$normal" \
            "environment variable is unset."
    echo "If you have a multi-threaded processor and would like"
    echo "to use multiple threads to build LilyPond faster,"
    echo "set \$MAKE_OPTIONS to -jN CPU_COUNT=N (where N is the"
    echo -e "number of threads you want to use plus one).\n"
    read -t $(expr $timeout + 5) proceed
fi



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
# and main lilypond repository ($main_repository).

if [[ $build == $main_repository/* ]]; then
    building_inside_main_repo="yes"
    source=$main_repository
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

echo "========================================"



######################## PREPARATION: ##########################

# if we're building directly in $main_repository, we don't want
# to make from scratch (e.g. erase everything before building)
# because that'd delete the repository and all of user's work.
cd $build || die "\$build doesn't exist."
if [[ "$from_scratch" == "yes" && "$build" != "$main_repository" ]]; then
    echo "You requested to build from scratch."
    echo -e "Removing $dircolor$build$normal directory"\
            "in $timeout seconds"
    echo "(press Ctrl-C to abort, Enter to skip delay)"
    read -t $timeout confirmation
    cd ../
    rm -rf $build || die "Failed to remove $build."
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
    # (This means we must be building outside $main_repository,
    # which in turn means that $source=$build.)
    # 
    # One thing we should check: maybe $build is a directory
    # containing *subdirectories* with lilypond builds?
    # (this would probably mean that the user made a mistake
    # and actually intended to specify a subdir of $build).
    # If that's the case, ask the user.
    #
    # If that's not the case, we simply are in a freshly created dir,
    # and we have to clone $main_repository to get the sources.
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
    git clone --no-checkout $main_repository $source || \
    die "Failed to clone lilypond repository"
    cd $source
    # checkout is a separate step,
    # because we don't want to get warnings about detached HEAD.
    git checkout --quiet HEAD || die "Failed to checkout files"
fi

# The value of -c option specifies what to build.
# It can be a commit (specified using a committish, a branch name,
# a tag, etc.) or the current state of working directory at
# $main_repository (if no value was specified).  The latter case
# means that we have to create a temporarty commit containing
# this state, so that it can be passed to the "satellite" repository
# (if any exists).  In any case, the commit to be built is passed
# using a special tag; since tags won't be automatically force-updated,
# old tags have to be deleted first.

git tag -d commit_to_build > /dev/null 2> /dev/null
cd $main_repository
git tag -d commit_to_build > /dev/null 2> /dev/null

if [ "$whichcommit" != "" ]; then
    git tag commit_to_build $whichcommit
else
    git diff --quiet HEAD
    # with --quiet, diff exits with 1 when there are any uncommitted changes.
    if [ $? == 0 ]; then
        git tag commit_to_build || die "Failed to create a tag"
    else
        # prepare a description for the temporary commit
        if (( $(git diff --color=never HEAD | wc --lines) < 50 ))
        then
            description=$(echo -e \
            "\nChanges:\n\n$(git diff HEAD)")
        else
            description=$(echo -e \
            "\nSummary of changes:\n\n$(git diff --stat HEAD)")
        fi

        echo "Creating a temporary commit..."
        git commit --quiet -a -m \
            "A temporary commit - work in progress to be compiled.
            $description" || die "Faile to create a temporary commit"
        git tag commit_to_build || die "Failed to create a tag"
        # restore previous (uncommitted) state
        git reset --quiet HEAD~1 \
        || die "Failed to restore previous (uncommitted) state"
    fi
fi

cd $source
if [[ "$building_inside_main_repo" == "no" ]]; then
    git fetch --quiet --tags || die "Failed to fetch from $main_repository."
fi

prev_branch=$(git branch --color=never | sed --quiet 's/* \(.*\)/\1/p')
prev_commit=$(git rev-parse HEAD)

git diff --quiet HEAD
# with --quiet, diff exits with 1 when there are any uncommitted changes.
if [ $? != 0 ]; then
    dirtytree=1
    echo "You have uncommitted changes. They will be saved using"
    echo "'git stash' and restored after the script finishes."
    git stash
    read -t $timeout delay
fi

if [[ "$regtests" == "yes" ]]; then
    git checkout --quiet master || die "Cannot checkout master."
else
    git checkout --quiet commit_to_build || \
    die "Cannot checkout desired commit."
fi



######################### BUILDING: ############################

# we should be inside $source now.
echo -e "Attempting to build lilypond: \n"
git log -n 1 | cat
echo ""
echo -e "inside directory \n  $dircolor$build$normal"
echo -e "in $timeout seconds (press Ctrl-C to abort," \
        "Enter to skip delay)\n"
read -t $timeout confirmation

# build dir might have been freshly created, so we need
# to check whether it contains necessary setup information.
cd $build
if [ "$(grep -s configure-srcdir config.make \
                     | sed s/configure-srcdir\ =\ //)" == "" ]; then
    # make doesn't know where the sources to build from
    # are located. Need to run autogen and configure
    cd $source; ./autogen.sh --noconfigure || die "Autogen failed."
    echo ""
    cd $build; $source/configure || die "Configure failed."
fi

# actual compiling.

compile_lilypond () {
    echo "----------------------------------------"
    cd $build
    if [[ "$only_bin" == "yes" ]]; then
        if [[ -f out/bin/lilypond ]]; then
            cd lily/
        else
            echo -e "\nLooks like this is the first time when LilyPond"
            echo "is built in this directory, so despite -b flag"
            echo "I will build everything, not just C++ files."
            read -t $(expr $timeout + 5) proceed
        fi
    fi
    time make $MAKE_OPTIONS || die "Make failed."

    echo "----------------------------------------"
    cd $source
    echo -e "$green""successfully built lilypond:$normal \n"
    git log -n 1 | cat
    echo ""
    echo -e "inside directory \n  $dircolor$build$normal"
}

STARTTIME=$(date +%s.%N)

compile_lilypond

if [[ "$regtests" == "yes" ]]; then
    echo "cleaning previous regtests..."
    make $MAKE_OPTIONS test-clean # crude, needs polishing.
    time make $MAKE_OPTIONS test-baseline || \
    die "Test baseline failed."
    git checkout --quiet commit_to_build || \
    die "Cannot checkout desired commit."
    compile_lilypond
    time make $MAKE_OPTIONS check || die "Regtest check failed."

    ENDTIME=$(date +%s.%N)
    TIMEDIFF=$(echo \
    $(echo "($ENDTIME - $STARTTIME) / 60" | bc) min \
    $(echo "($ENDTIME - $STARTTIME) % 60" | bc) sec \
    )
    echo "Total time spent doing regression tests: $TIMEDIFF"
fi

# restore previous state of main_repository (if necessary).
cd $source
if [[ "$building_inside_main_repo" == "yes" || "$dirtytree" != "" ]]
# (we don't want to restore before-build-state in satellite repos)
then
    git checkout --quiet $prev_commit || \
    die "Problems with checking out previous HEAD."
    # there may be errors when initial state was a detached HEAD
    # (no branch), but that's not a problem
    git checkout --quiet $prev_branch 2> /dev/null

    if [[ "$dirtytree" != "" ]]; then
	echo -e "\n$green""Restoring uncommitted changes" \
	"from stash.$normal"
	git stash apply
    fi
fi

echo "________________________________________"

if [[ "$regtests" == "yes" ]]; then
    firefox file://$build/out/test-results/index.html &
fi
