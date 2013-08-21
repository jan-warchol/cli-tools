#!/bin/bash

die() { # in case of error
    echo -e "\e[00;31m$1\e[00m"
    exit 1
}

which git
# if there's no git on the system, install it
if [ $? != 0 ]; then
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install git
fi

# get packages needed for compiling lilypond
sudo apt-get build-dep lilypond \
|| die "Failed to install build dependencies for LilyPond"
sudo apt-get install autoconf || die "Failed to install autoconf"
sudo apt-get install dblatex || die "Failed to install dblatex"
sudo apt-get install texlive-lang-cyrillic \
|| die "Failed to install texlive-lang-cyrillic"

# clone lilypond sources
git clone git://git.sv.gnu.org/lilypond.git $HOME/lilypond-sources \
|| die "Failed to clone LilyPond"

echo 'export LILYPOND_GIT=$HOME/lilypond-sources' | tee -a $HOME/.bashrc