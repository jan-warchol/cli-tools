#!/bin/bash

die() {
    echo -e "\e[00;31m$1\e[00m"
    exit 1
}

# libraries for compiling git from source
sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
sudo git clone git://git.kernel.org/pub/scm/git/git.git \
|| die "Failed to clone git sources"
cd /repos/git
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install
sudo apt-get remove git

# DVD decryption
sudo apt-get install libdvdread4 || die "Failed to download DVD decoders"
sudo /usr/share/doc/libdvdread4/install-css.sh \
|| die "Failed to install DVD decoders"

# a program for changing line endings from windows to unix
sudo apt-get install flip || die "Failed to install flip"

# a program for changing screen brightness
sudo apt-get install xbacklight || die "Failed to install xbacklight"

# a program for opening files with GUI programs from command line (gnome-open)
sudo apt-get install libgnome2-0 || die "Failed to install gnome-open"

# install keepass2.  first two commands might not be necessary.
#sudo apt-add-repository ppa:jtaylor/keepass
#sudo apt-get update
sudo apt-get install keepass2 || die "Failed to install KeePass"

sudo apt-get install gimp || die "Failed to install GIMP"

sudo apt-get install imagemagick || die "Failed to install ImageMagick"

sudo apt-get install kate || die "Failed to install Kate"

sudo apt-get install vlc || die "Failed to install VLC"

# TODO install frescobaldi
