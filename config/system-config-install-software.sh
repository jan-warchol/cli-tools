#!/bin/bash

die() {
    echo -e "\e[00;31m$1\e[00m"
    exit 1
}

# libraries for compiling git from source
sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
sudo git clone git://git.kernel.org/pub/scm/git/git.git \
$MY_REPOSITORIES/git || die "Failed to clone git sources"
cd /repos/git
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install
sudo apt-get remove git

# DVD decryption
sudo apt-get -qy install libdvdread4
|| die "Failed to download DVD decoders"
sudo /usr/share/doc/libdvdread4/install-css.sh \
|| die "Failed to install DVD decoders"

# a program for changing line endings from windows to unix
sudo apt-get -qy install flip || die "Failed to install flip"

# a program for changing screen brightness
sudo apt-get -qy install xbacklight || die "Failed to install xbacklight"

# a program for opening files with GUI programs from command line (gnome-open)
sudo apt-get -qy install libgnome2-0 || die "Failed to install gnome-open"

sudo apt-get -qy install keepass2 || die "Failed to install KeePass"
# a library enabling auto-type in keepass:
sudo apt-get -qy install xdotool || die "Failed to install xdotool"

sudo apt-get -qy install gimp || die "Failed to install GIMP"

sudo apt-get -qy install imagemagick || die "Failed to install ImageMagick"

sudo apt-get -qy install kate || die "Failed to install Kate"

sudo apt-get -qy install vlc || die "Failed to install VLC"

# download Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# 32-bit version would be:
# cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -

# LilyPond, with dependencies:
sudo apt-get -qy build-dep lilypond
|| die "Failed to install build dependencies for LilyPond"\
git clone git://git.sv.gnu.org/lilypond.git \
$MY_REPOSITORIES/lilypond-git || die "Failed to clone LilyPond"

# Frescobaldi, with dependencies:
sudo apt-get -qy install python || die "Failed to install python"
sudo apt-get -qy install python-qt4 || die "Failed to install PyQt4"
sudo apt-get -qy install python-poppler-qt4 \
|| die "Failed to install python-poppler-qt4"
sudo apt-get -qy install python-pypm \
|| die "Failed to install python-portmidi"
git clone git://github.com/wbsoft/frescobaldi.git \
$MY_REPOSITORIES/frescobaldi || die "Failed to clone Frescobaldi"

