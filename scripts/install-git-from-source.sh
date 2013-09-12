#!/bin/bash
# this script will clone git sources and install git from that.

die() {
    echo -e "\e[00;31m$1\e[00m"
    exit 1
}

# libraries for compiling git from source
sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
sudo git clone git://git.kernel.org/pub/scm/git/git.git \
$MY_REPOSITORIES/git || die "Failed to clone git sources"
cd $MY_REPOSITORIES/git || die "Git sources not found"
sudo make prefix=/usr/local all || die "Failed to compile git"
sudo make prefix=/usr/local install || die "Failed to install git"

# remove previously installed version (i.e. an older one)
sudo apt-get remove git || die "Failed to remove old git"
