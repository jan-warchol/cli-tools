#!/bin/bash

set -x
set -u
set -e


# DVD decryption
sudo apt-get -qy install libdvdread4
sudo /usr/share/doc/libdvdread4/install-css.sh

# a program for changing line endings from windows to unix
sudo apt-get -qy install flip

# misc stuff
sudo apt-get -qy install gparted
sudo apt-get -qy install guake
sudo apt-get -qy install kompare
sudo apt-get -qy install gksu
sudo apt-get -qy install indicator-multiload

# a program for changing screen brightness
sudo apt-get -qy install xbacklight

# a program for opening files with GUI programs from command line (gnome-open)
sudo apt-get -qy install libgnome2-0

sudo apt-get -qy install keepass2
# a library enabling auto-type in keepass:
sudo apt-get -qy install xdotool

sudo apt-get -qy install gimp

sudo apt-get -qy install imagemagick

sudo apt-get -qy install kate

sudo apt-get -qy install vlc

sudo apt-get -qy install guake

# download Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# 32-bit version would be:
# cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -

# LilyPond, with dependencies:
sudo apt-get -qy build-dep lilypond
sudo apt-get -qy install autoconf
sudo apt-get -qy install dblatex
sudo apt-get -qy install texlive-lang-cyrillic
git clone git://git.sv.gnu.org/lilypond.git \
$MY_REPOSITORIES/lilypond-git

# Frescobaldi, with dependencies:
sudo apt-get -qy install python
sudo apt-get -qy install python-qt4
sudo apt-get -qy install python-poppler-qt4
sudo apt-get -qy install python-pypm
git clone git://github.com/wbsoft/frescobaldi.git \
$MY_REPOSITORIES/frescobaldi
cd $MY_REPOSITORIES/frescobaldi
sudo python setup.py install
cd $ALL_MY_DATA

# PyPdf library, needed for gotowa-teczka.sh
cd ~ && wget -O - "http://pybrary.net/pyPdf/pyPdf-1.13.tar.gz" | tar xzf -
cd pyPdf-1.13
# i think building isn't necessary
# sudo python setup.py build
sudo python setup.py install
# TODO: remove leftovers?
# alternative version of the library could be obtained from here:
# git clone https://github.com/mstamy2/PyPDF2/ \
# $MY_REPOSITORIES/pypdf2


# make a backup of polish keyboard layout
# sudo cp /usr/share/X11/xkb/symbols/pl /usr/share/X11/xkb/symbols/pl.backup
# overwrite polish keyboard layout with my own layout
# sudo cp -f ~/janek-keyboard-layout /usr/share/X11/xkb/symbols/pl

echo "Setting TrackPoint sensitivity to:"
echo 255 | sudo tee /sys/devices/platform/i8042/serio1/serio2/sensitivity
echo "Setting TrackPoint speed to:"
echo 255 | sudo tee /sys/devices/platform/i8042/serio1/serio2/speed
echo "Setting TrackPoint press-to-select to:"
echo 1 | sudo tee /sys/devices/platform/i8042/serio1/serio2/press_to_select
