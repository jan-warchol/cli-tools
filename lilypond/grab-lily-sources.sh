#!/bin/bash

# this script will set up everything (hopefully) that you
# need to compile LilyPonda from source - that is, it will:
# - install appropriate version of git
# - download required libraries
# - clone lilypond sources
# - clone scripts by Janek that make building easier
# - set environment variables used by various lilypond scripts.
#
# You will be asked where the lilypond sources and Janek's
# scripts should be placed.
#
# The script was written for Debian-based Linux distributions
# that use apt package manager (for example Ubuntu).

# TODO:
# document 'lily' bash function
# don't use sudo inside the script.  Instead, require that the script
# is ran with sudo.
# add options: default yes, and quiet apt-get?
# and building default lilypond.


#########################################################
# helper functions:

die() { # in case of error
    echo "$1. Exiting."
    exit 1
}

check_version() {
    # returns 0 (i.e. success) if the first argument is greater
    # or equal to the second (interpreted as version numbers)
    [  "$2" = "$(echo -e "$2\n$1" | sort -V | head -n1)" ]
}

install_git() {
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install git
}

##########################################################

# Where all lilypond stuff should be placed?
if [ -n "$LILYPOND_GIT" ]; then
    echo "It seems that you already have some LilyPond"
    echo "configuration: your \$LILYPOND_GIT points to"
    echo -e "  $LILYPOND_GIT\n"
    sleep 3
    location="$(readlink -m $LILYPOND_GIT/..)"
else
    echo "Where would you like LilyPond stuff to be placed?"
    echo "Please specify a path relative to your home directory."
    echo "Subdirectories with LilyPond sources, binaries and"
    echo "building scripts will be placed there."
    read location
    location=$HOME/$location
    LILYPOND_GIT="$location/lilypond-sources"
fi
if [ -z "$LILYPOND_BUILD_DIR" ]; then
    LILYPOND_BUILD_DIR="$location/lilypond-builds"
fi
JANEK_SCRIPTS="$location/janek-scripts"

echo "I will download LilyPond sources and other stuff into"
echo -e "  $location \n"
sleep 5
mkdir -p $location

# make sure a recent enough version of git is installed
which git &>/dev/null
if [ $? != 0 ]; then
    echo "Git isn't installed on your computer. Installing now..."
    install_git
else
    # is installed git version recent enough?
    git_required="1.8"
    # there's a build number after the last dot.
    git_installed=$(git --version | sed 's/git\ version\ //' | sed 's/.[^.]*$//')
    check_version $git_installed $git_required
    if [ $? = 1 ]; then
        echo "You have git version $git_installed."
        echo "Required version is $git_required."
        echo "Installing newer git version..."
        install_git
    fi
fi

# get packages needed for compiling lilypond
sudo apt-get build-dep lilypond \
|| die "Failed to install build dependencies for LilyPond"
sudo apt-get install autoconf || die "Failed to install autoconf"
sudo apt-get install dblatex || die "Failed to install dblatex"
sudo apt-get install texlive-lang-cyrillic \
|| die "Failed to install texlive-lang-cyrillic"

# clone lilypond sources
if [ ! -d "$LILYPOND_GIT/.git" ]; then
    # $LILYPOND_GIT doesn't exist yet or is not a git repository
    git clone git://git.sv.gnu.org/lilypond.git $LILYPOND_GIT \
    || die "Failed to clone LilyPond"
fi

# also, clone a repository with helpful scripts written by Janek:
if [ ! -d "$JANEK_SCRIPTS/.git" ]; then
    git clone http://github.com/janek-warchol/cli-tools.git $JANEK_SCRIPTS \
    || die "Failed to clone Janek's scripts"
fi

lilypond_bash_settings="
# environment variables and aliases for LilyPond work:
export LILYPOND_GIT=$LILYPOND_GIT
export LILYPOND_BUILD_DIR=$LILYPOND_BUILD_DIR

alias build-lilypond=$JANEK_SCRIPTS/lilypond/build-lily.sh

lily() {
    # A shorthand for running custom-built LilyPond versions
    # from command line. Usage example:
    #   lily master somefile
    # this will compile 'somefile' using LilyPond from 'master'
    # subdirectory of \$LILYPOND_BUILD_DIR (assuming it exists).

    lily_version=\"\$1\"
    shift
    \"\$LILYPOND_BUILD_DIR/\$lily_version/out/bin/lilypond\" \"\$@\"
}
"
# add the above settings to bash initialization file
echo -en "$lilypond_bash_settings" | tee -a ~/.bashrc
# use them in this script, so that calling build-lily will work:
eval "$lilypond_bash_settings"

echo -en "
===============================================================
The script was successful. Now you have LilyPond source code in
  $LILYPOND_GIT
and some scripts and other stuff written by Janek Warchoł in
  $JANEK_SCRIPTS.
To complete the \"installation\", please restart your terminal
(some settings need to be reloaded).

After that, use 'build-lilypond' command to compile lilypond. Run
  build-lilypond --help
to learn how to use it. For a more detailed introduction, see
  $JANEK_SCRIPTS/lilypond/intro-text.md
===============================================================
"
