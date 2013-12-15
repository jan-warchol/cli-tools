#!/bin/bash

die() {
    echo -e "\e[00;31m$1\e[00m"
    exit 1
}


# DVD decryption
sudo apt-get -qy install libdvdread4 \
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

sudo apt-get -qy install guake || die "Failed to install guake"

# download Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# 32-bit version would be:
# cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -

# LilyPond, with dependencies:
sudo apt-get -qy build-dep lilypond \
|| die "Failed to install build dependencies for LilyPond"
sudo apt-get -qy install autoconf || die "Failed to install autoconf"
sudo apt-get -qy install dblatex || die "Failed to install dblatex"
sudo apt-get -qy install texlive-lang-cyrillic \
|| die "Failed to install texlive-lang-cyrillic"
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
cd $MY_REPOSITORIES/frescobaldi
sudo python setup.py install || die "Failed to install Frescobaldi"
cd $ALL_MY_DATA

# PyPdf library, needed for gotowa-teczka.sh
cd ~ && wget -O - "http://pybrary.net/pyPdf/pyPdf-1.13.tar.gz" | tar xzf - \
|| die "Failed to download PyPdf"
cd pyPdf-1.13
# i think building isn't necessary
# sudo python setup.py build || die "Failed to build PyPdf"
sudo python setup.py install || die "Failed to install PyPdf"
# TODO: remove leftovers?
# alternative version of the library could be obtained from here:
# git clone https://github.com/mstamy2/PyPDF2/ \
# $MY_REPOSITORIES/pypdf2 || die "Failed to clone PyPdf2"

