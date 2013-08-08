#!/bin/bash

# Copy my configuration files from cli-tools repository
# to appropriate locations.  Can be ran multiple times.


if [ -f ~/.bashrc ]; then
    cp ~/.bashrc ~/.bashrc.backup
fi
cp $MY_CONFIGS/bashrc ~/.bashrc


if [ -f ~/.inputrc ]; then
    cp ~/.inputrc ~/.inputrc.backup
fi
cp $MY_CONFIGS/inputrc ~/.inputrc


if [ -f ~/.profile ]; then
    cp ~/.profile ~/.profile.backup
fi
cp $MY_CONFIGS/profile ~/.profile


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

