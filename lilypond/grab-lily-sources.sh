#!/bin/bash

# this script will set up everything (hopefully) that you
# need to compile LilyPonda from source - that is, it will:
# - install appropriate version of git
# - download required libraries
# - clone lilypond sources
# - clone scripts by Janek that make building easier
# - set environment variables used by these script.
#
# You will be asked where the lilypond sources and Janek's
# scripts should be placed.
#
# The script was written for Debian-based Linux distributions
# using apt package manager (for example Ubuntu).


#########################################################
# helper functions:

die() { # in case of error
    echo "$1. Exiting."
    exit 1
}

checkversion() {
    # returns 0 (i.e. success) if the first argument is greater
    # or equal to the second (interpreted as version numbers)
    [  "$2" = "$(echo -e "$2\n$1" | sort -V | head -n1)" ]
}

##########################################################

echo "Where would you like LilyPond stuff to be placed?"
echo "Please specify a path relative to your home directory."
read location
location=$HOME/$location

echo "I will download LilyPond sources and other stuff into"
echo -e "$location \n"
sleep 4


which git &>/dev/null
# if there's no git on the system, install it
if [ $? != 0 ]; then
    echo "You don't seem to have git installed - downloading..."
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install git
else # is installed git version recent enough?
    git_required="1.8"
    # remove everything after last dot - its build number, not interesting
    git_installed=$(git --version | sed 's/git\ version\ //' | sed 's/.[^.]*$//')
    checkversion $git_installed $git_required
    if [ $? = 1 ]; then
        echo "It seems that you have an old version of git installed"
        echo "(you have $git_installed, required version is $git_required)."
        echo "Installing newer git version..."
        sudo add-apt-repository ppa:git-core/ppa
        sudo apt-get update
        sudo apt-get install git
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
git clone git://git.sv.gnu.org/lilypond.git $location/lilypond-sources \
|| die "Failed to clone LilyPond"

# set environment variables used by other scripts
echo "export LILYPOND_GIT=$location/lilypond-sources" | tee -a $HOME/.bashrc
echo "export LILYPOND_BUILD_DIR=$location/lilypond-builds" | tee -a $HOME/.bashrc

# also, clone a repository with helpful scripts written by Janek:
git clone https://github.com/janek-warchol/cli-tools.git $location/janek-scripts \
|| die "Failed to clone Janek's scripts"

echo " "
echo "The script was successful. Now you have LilyPond source code in"
echo "$location/lilypond-sources/"
echo "and some scripts and other stuff written by Janek Warchoł in"
echo "$location/janek-scripts/."
echo " "
echo "You probably want to compile LilyPond now. This can be easily done"
echo "using build-lily.sh script written by Janek, which can be found in"
echo "$location/janek-scripts/lilypond/"
echo "Run"
echo "$location/janek-scripts/lilypond/build-lily.sh --help"
echo "to see how the script works."
