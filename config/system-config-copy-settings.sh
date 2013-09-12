#!/bin/bash

# Copy my configuration files from cli-tools repository
# to appropriate locations.  Can be ran multiple times.


if [ -f ~/.bashrc ]; then
    cp ~/.bashrc ~/.bashrc.backup
fi
cp $MY_CONFIGS/bashrc ~/.bashrc


if [ -f ~/.gnomerc ]; then
    cp ~/.gnomerc ~/.gnomerc.backup
fi
cp $MY_CONFIGS/gnomerc ~/.gnomerc


if [ -f ~/.inputrc ]; then
    cp ~/.inputrc ~/.inputrc.backup
fi
cp $MY_CONFIGS/inputrc ~/.inputrc


if [ -f ~/.profile ]; then
    cp ~/.profile ~/.profile.backup
fi
cp $MY_CONFIGS/profile ~/.profile


if [ -f ~/.config/user-dirs.dirs ]; then
    cp ~/.config/user-dirs.dirs ~/.config/user-dirs.dirs.backup
fi
cp $MY_CONFIGS/user-dirs.dirs ~/.config/user-dirs.dirs


# When git > 1.7.10 becomes widespread,
# this probably could be used instead:
# [include]
#	path = $MY_CONFIGS/gitconfig

if [ -f ~/.gitconfig ]; then
    cp ~/.gitconfig ~/.gitconfig.backup
fi
cp $MY_CONFIGS/gitconfig ~/.gitconfig


# load my cron jobs
# crontab $MY_CONFIGS/cron.jobs

# make a backup of polish keyboard layout
# sudo cp /usr/share/X11/xkb/symbols/pl /usr/share/X11/xkb/symbols/pl.backup
# overwrite polish keyboard layout with my own layout
# sudo cp -f $MY_CONFIGS/janek-keyboard-layout /usr/share/X11/xkb/symbols/pl

echo "Setting TrackPoint sensitivity to:"
echo 255 | sudo tee /sys/devices/platform/i8042/serio1/serio2/sensitivity
echo "Setting TrackPoint speed to:"
echo 255 | sudo tee /sys/devices/platform/i8042/serio1/serio2/speed
echo "Setting TrackPoint press-to-select to:"
echo 1 | sudo tee /sys/devices/platform/i8042/serio1/serio2/press_to_select
