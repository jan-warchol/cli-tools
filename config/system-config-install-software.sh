#!/bin/bash

die() {
    echo -e "\e[00;31m$1\e[00m"
    exit 1
}

# libraries for compiling git from source
sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
sudo git clone git://git.kernel.org/pub/scm/git/git.git
cd /repos/git
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install
sudo apt-get remove git

# DVD decryption
sudo apt-get install libdvdread4
sudo /usr/share/doc/libdvdread4/install-css.sh

# a program for changing line endings from windows to unix
sudo apt-get install flip

# a program for changing screen brightness
sudo apt-get install xbacklight

# a program for opening files with GUI programs from command line (gnome-open)
sudo apt-get install libgnome2-0

# install keepass2.  first two commands might not be necessary.
#sudo apt-add-repository ppa:jtaylor/keepass
#sudo apt-get update
sudo apt-get install keepass2

sudo apt-get install gimp

sudo apt-get install imagemagick

sudo apt-get install kate

sudo apt-get install vlc

# TODO install frescobaldi
