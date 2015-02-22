#!/bin/bash

# PyPdf library, needed for gotowa-teczka.sh
cd ~ && wget -O - "http://pybrary.net/pyPdf/pyPdf-1.13.tar.gz" | tar xzf -
cd pyPdf-1.13
# i think building isn't necessary
# sudo python setup.py build
sudo python setup.py install
# TODO: remove leftovers?
# alternative version of the library could be obtained from here:
# git clone https://github.com/mstamy2/PyPDF2/ $OTHER_REPOS/pypdf2

# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# 32-bit version would be:
# cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -

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
