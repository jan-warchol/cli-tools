#!/bin/bash

scriptpath=$0
[[ "$0" =~ ^"$HOME"(/|$) ]] && scriptpath="~${0#$HOME}"

helpmessage="This script will build LilyPond for you.

You should have a git repository with LilyPond source code,
and an environment variable \$LILYPOND_GIT pointing there.
You can use 'grab-lily-sources.sh' script to configure that.

Usage: with no options specified, lilypond will be built in
\$LILYPOND_BUILD_DIR/current, using the current state of the
working directory from \$LILYPOND_GIT repository.


OPTIONS (see also Examples at the bottom)

-c <commit> tells the script to compile a particular commit
   instead of current working directory state. This can be
   a SHA1 commit ID, branch name or a tag name. This value
   will also be used as the name of the build subdirectory,
   unless overridden with a -d option.

-d <path> is the directory where the build will happen.
   This can be an absolute path or a path relative to
   \$LILYPOND_BUILD_DIR.

-s option means to \"build from scratch\", i.e. delete previous
   build results from target directory before compiling again.

-b option tells make just to compile C++ files, without walking
   through all other files.  If you don't need other files to be
   compiled, use this option to make building faster.

-h displays this help.

-m \"<branches>\" will merge additional branches of LilyPond source
   code into the build.  This can be handy when you'd like to
   have a LilyPond version that combines several experimental
   (not yet released) features.  Also, it will probably be more
   convenient than trying to do the merge yourself.
   Branch names should be separated by spaces, and the full list
   enclosed in quotation marks.

-j <value> sets the number of processor threads used for building.
   By default the script uses all available threads, but if this
   causes your computer to slow down too much, you can override
   that decision using this option.
   <value> should be the number of threads you want to use plus one.

-o <value> specify custom options for 'make'.

-t <value> sets the amount of time for which the script is paused
   when the user has to check whether the setup is correct.

-r compile regression tests.

-l build in the current working directory.

-f <path> take sources from this directory, not \$LILYPOND_GIT.

-w don't use colors in output, only black&White.

Sometimes it is useful to have multiple LilyPond builds,
or to be able to continue changing source code while the
previous state is being compiled.  You can do this quite
easily - make sure your \$LILYPOND_BUILD_DIR variable points
to a directory outside of \$LILYPOND_GIT, and compile lilypond
in its subdirectories (using -c and/or -d options).

In such situations (i.e. when the build directory isn't inside
\$LILYPOND_GIT) the script will clone lilypond repository into
that build directory, so that it will be completely separate
from your main repository.  This way you can continue your work,
switch branches etc. without affecting the code that is being
compiled at the moment.

Note that these \"satellite build repositories\" work similarly
to \"regular builds\" inside \$LILYPOND_GIT - you don't have to
commit your work to build it, and if you make changes, you can
rebuild them in the same satellite repo without having to copy
things around or rebuilding from scratch.  The script handles
all this quite fine.

This script can be called from any directory whatsoever (you don't
have to be inside \$LILYPOND_GIT or \$LILYPOND_BUILD_DIR).


EXAMPLES

build-lily.sh
will compile current state of the working directory from
\$LILYPOND_GIT inside \$LILYPOND_BUILD_DIR/current

build-lily.sh -c master
will compile \"master\" branch from \$LILYPOND_GIT repository
(regardless of which branch is currently checked out there)
inside \$LILYPOND_BUILD_DIR/master

build-lily.sh -c release/2.16.2-1 -d stable
will compile the commit tagged \"release/2.16.2-1\" inside
\$LILYPOND_BUILD_DIR/stable

build-lily.sh -c master -m \"mybranch origin/dev/something\"
will compile \"master\" branch merged with local branch
\"mybranch\" and remote branch \"origin/dev/something\",
inside \$LILYPOND_BUILD_DIR/master+mybranch+dev_something.


AUTHOR

Written by Janek Warchoł (janek.lilypond@gmail.com)
for the GNU LilyPond project (lilypond.org).

Press q to close this help message.
"

# for measuring time performance.  See end of the script.
STARTTIME=$(date +%s.%N)

if [[ "$1" == "help" || "$1" == "--help" ]]; then
    help="yes"
fi

# TODO:
# add a dry-run option
# only inform about stashing changes when building in LILYPOND_GIT
# abort when given invalid options
# rewrite in python? :)

while getopts "bc:d:f:hj:lm:o:rst:w" opts; do
    case $opts in
    b)
        only_bin="yes";;
    c)
        whichcommit=$OPTARG
        whichdir=$(echo $OPTARG | sed -e s'/origin\///'g)
        ;;
    d)
        whichdir=$OPTARG
        dont_override_dirname="yes"
        ;;
    f)
        main_repository=$OPTARG;;
    h)
        help="yes";;
    j)
        threads=$OPTARG;;
    l)
        whichdir=$(pwd);;
    m)
        branches_to_merge=$OPTARG;;
    o)
        MAKE_OPTIONS=$OPTARG;;
    r)
        regtests="yes";;
    s)
        from_scratch="yes";;
    t)
        timeout=$OPTARG;;
    w)
        nocolors="--color=never";;
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

# append names of merged branches to dirname
if [[ -z $dont_override_dirname && -n "$branches_to_merge" ]]; then
    whichdir=$whichdir+$(echo $branches_to_merge | \
    sed -e s'/origin\///'g | \
    sed -e s'/\//_/'g | \
    sed -e s'/ /+/'g | \
    sed -e s'/[^A-Za-z0-9.,_\(\)\-+]/-/'g)
fi

if [ -z $threads ]; then
    # no cpu count was specified -> grab from processor info
    threads=$(expr 1 + $(grep -c ^processor /proc/cpuinfo))
    # prepend this deduced threading to $MAKE_OPTIONS.
    # (threading settings from $MAKE_OPTIONS will take precedence)
    MAKE_OPTIONS="-j$threads CPU_COUNT=$threads $MAKE_OPTIONS"
else
    # -j was explicitly specified -> place the threading
    # at the end (overridding threading from $MAKE_OPTIONS).
    MAKE_OPTIONS="$MAKE_OPTIONS -j$threads CPU_COUNT=$threads"
fi

# amount of time that we give to the user to check
# information at various moments (default value, in seconds)
if [ -z $timeout ]; then
    timeout=15
fi

# define colors, unless the user turned them off.
if [ -z $nocolors ]; then
    normal="\e[00m"
    red="\e[00;31m"
    green="\e[00;32m"
    yellow="\e[00;33m"
    blue="\e[00;34m"
    violet="\e[00;35m"
    cyan="\e[00;36m"
    gray="\e[00;37m"
    bold="$(tput bold)"
    dircolor=$violet
fi

die() {
    # in case of some error...
    echo -e "$red$@$normal"
    echo Exiting.
    if [ "$dirtytree" != "" ]; then
        echo -e "$red""Warning!$normal"
        echo "When this script was ran, the HEAD of $source"
        echo "repository was $prev_commit"
        echo "(branch $prev_branch)"
        echo "and there were uncommitted changes on top of that commit."
        echo "They were saved using 'git stash' and you should be able"
        echo "to get them back using 'git stash apply'."
    fi
    exit 1
}



##################### GATHER INFORMATION: #######################
# get the "version" of the script (actually, the committish of the
# HEAD in the git repository where the script resides, if exists).
current_working_dir=$(pwd)
cd "$( dirname "${BASH_SOURCE[0]}" )"
git rev-parse 2> /dev/null
if [ $? = 0 ]; then
    echo "This is LilyPond-building script, version" \
        "$(git log -1 --format=%h)."
fi
cd $current_working_dir
echo -e "LilyPond sources for building are taken from"
echo -e "  $main_repository"
sleep 1

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
# in case $LILYPOND_BUILD_DIR is unset, set it.
# By default, $LILYPOND_BUILD_DIR is outside $LILYPOND_GIT
# because if multiple builds were created in the same repository
# then they wouldn't work properly when branches in that repo
# would be switched.
if [ -z "$LILYPOND_BUILD_DIR" ]; then
    echo '$LILYPOND_BUILD_DIR variable is unset.'
    export LILYPOND_BUILD_DIR="$(readlink -m \
           $main_repository/../lilypond-builds)"
    echo "Setting it to $LILYPOND_BUILD_DIR."
    read -t 5 proceed
fi
# make sure that $LILYPOND_BUILD_DIR directory exists:
mkdir -p $LILYPOND_BUILD_DIR

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
    if [[ $build == $LILYPOND_BUILD_DIR/* ]]; then
        echo -e "Removing $dircolor$build$normal directory"\
                "in $timeout seconds"
        echo "(press Ctrl-C to abort, Enter to skip delay)"
        read -t $timeout dummy
    else
        # be extra-careful if removing something outside
        # $LILYPOND_BUILD_DIR.
        echo -e "Directory $dircolor$build$normal"
        echo "and all its content will be removed."
        echo "This operation cannot be undone. Proceed? (yes/no)"
        read decision
        if [ "$decision" != "yes" ]; then die "Removing aborted."; fi
    fi
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

cd $source
git tag -d commit_to_build &>/dev/null
for tag in $(git tag | grep to_be_merged/); do
    git tag -d $tag &>/dev/null
done

cd $main_repository
git tag -d commit_to_build &>/dev/null
for tag in $(git tag | grep to_be_merged/); do
    git tag -d $tag &>/dev/null
done

for branch in $branches_to_merge; do
    git tag -f to_be_merged/$branch $branch
    if [ $? != 0 ]; then
        echo "Trying origin/$branch instead... "
        git tag -f to_be_merged/$branch "origin/$branch" || \
        die "$normal""It seems that the branch/commit/tag" \
            "'$red$branch$normal'" \
            "\ndoes not exist or cannot be reached from repository" \
            "\n  $dircolor$main_repository$normal"
        echo success.
    fi
done

if [ "$whichcommit" != "" ]; then
    git tag commit_to_build $whichcommit
    if [ $? != 0 ]; then
        if [[ $whichcommit == release/* ]]; then
            echo "Trying $whichcommit-1 instead... "
            git tag commit_to_build "$whichcommit-1" || \
            die "$normal""It seems that the branch/commit/tag" \
                "'$red$whichcommit$normal'" \
                "\ndoes not exist or cannot be reached from repository" \
                "\n  $dircolor$main_repository$normal"
            echo success.
        else
            echo "Trying origin/$whichcommit instead... "
            git tag commit_to_build "origin/$whichcommit" || \
            die "$normal""It seems that the branch/commit/tag" \
                "'$red$whichcommit$normal'" \
                "\ndoes not exist or cannot be reached from repository" \
                "\n  $dircolor$main_repository$normal"
            echo success.
        fi
    fi
else
    # check if there are any untracked files.
    git ls-files --other --exclude-standard | sed --quiet q1
    if [[ $? != 0 && "$building_inside_main_repo"="no" ]]; then
        echo -e "$yellow""\nWarning:$normal" \
        "you have untracked files in your"
        echo "$main_repository repository."
        echo "They will not be included in the build."
        echo "If you need them, you should probably commit them:"
        echo ""
        git ls-files --other --exclude-standard
        echo ""
        read -t $timeout dummy
        echo "----------------------------------------"
    fi
    git diff --quiet HEAD
    # with --quiet, diff exits with 1 when there are any uncommitted changes.
    if [ $? == 0 ]; then
        git tag commit_to_build || die "Failed to create a tag"
    else
        # prepare a description for the temporary commit
        if (( $(git diff --color=never HEAD | wc --lines) < 50 ))
        then
            description=$(echo -e \
            "\nChanges:\n\n$(git diff $nocolors HEAD)")
        else
            description=$(echo -e \
            "\nSummary of changes:\n\n$(git diff $nocolors --stat HEAD)")
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
    echo "You have uncommitted changes in"
    echo -e "  $dircolor$build$normal"
    echo "repository. They will be saved using 'git stash'"
    echo "and restored after the script finishes."
    git stash save "Stashed during build $(date +"%Y-%m-%d_%H:%M")"
    read -t $timeout dummy
fi

if [[ "$regtests" == "yes" ]]; then
    git checkout --quiet master || die "Cannot checkout master."
else
    git checkout --quiet commit_to_build || \
    die "Cannot checkout desired commit."
fi

base=$(git rev-parse commit_to_build)
for branch in $(git tag | grep to_be_merged/); do
    echo -e "\nMerging branch" \
         \'$blue$(echo $branch | sed 's/to_be_merged\///')$normal\' \
         into $whichcommit:

    # We first rebase, because we don't want to introduce unwanted
    # commits to the build. For example, if the history is like this:
    #
    #           X
    #          /
    # A---B---C---D
    #
    # and we want to compile commit A with X added, but we don't
    # want B and C, we need to do a 'git rebase --onto A C X'
    # to get this:
    #
    #   X'
    #  /
    # A---B---C---D
    #
    # so that we can merge X' into A and don't get B and C.

    echo "Removing unwanted commits from the branch..."
    git rebase --onto $base $(git merge-base origin/master $branch) $branch || \
    {
        echo -e "$bold""Aborting the rebase.$normal\n"
        echo -e "Failed to remove unwanted commits from branch" \
                "$(echo $branch | sed 's/to_be_merged\///')"
        echo "The build may succeed nevertheless, but you'll have some"
        echo "stuff that you probably didn't want to have. For example,"
        echo "if you tried to merge a new experimental feature with"
        echo "an old release, you may get a bunch of changes from the"
        echo "newer releases as well."
        echo ""
        echo -e "$bold""Trying to continue the merge...$normal\n"
        git rebase --abort
    }
    git tag -f $branch

    git checkout --quiet commit_to_build
    git merge --commit --no-edit $branch || \
    {
        echo -e "$bold\nDetails of the failed merge:$normal\n"
        git status;
        echo -e "Aborting the merge."
        git merge --abort
        die "Failed to merge $(echo $branch | sed 's/to_be_merged\///')"
    }
    git tag -f commit_to_build &>/dev/null
    merged="$merged$(echo " $branch," | sed 's/to_be_merged\///')"
done
if [ "$merged" != "" ]; then
    merge_message="Merge$merged into $whichcommit"
    git commit --amend --message="$merge_message"
fi
git tag -f commit_to_build &>/dev/null



######################### BUILDING: ############################

# we should be inside $source now.
echo -e "Attempting to build lilypond: \n"
git log $nocolors -n 1 | cat
echo ""
echo -e "inside directory \n  $dircolor$build$normal"
echo -e "in $timeout seconds (press Ctrl-C to abort," \
        "Enter to skip delay)\n"
read -t $timeout dummy
commit_id=$(git rev-parse HEAD)

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
            read -t $(expr $timeout + 5) dummy
        fi
    fi
    time make $MAKE_OPTIONS || die "Make failed (commit $commit_id)."

    echo "----------------------------------------"
    cd $source
    echo -e "$green""successfully built lilypond:$normal \n"
    git log $nocolors -n 1 | cat
    echo ""
    echo -e "inside directory \n  $dircolor$build$normal"
}

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
    firefox file://$build/out/test-results/index.html &
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

ENDTIME=$(date +%s.%N)
TIMEDIFF=$(echo \
    $(echo "($ENDTIME - $STARTTIME) / 60" | bc) min \
    $(echo "($ENDTIME - $STARTTIME) % 60" | bc) sec \
)
echo "Total time spent: $TIMEDIFF"
