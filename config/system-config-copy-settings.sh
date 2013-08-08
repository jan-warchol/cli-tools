#!/bin/bash

# configure my user account. Run this once.

# create an .inputrc file and link to the content
echo '$include $MY_CONFIGS/inputrc' | tee -a $HOME/.inputrc

# load my cron jobs
# crontab $MY_CONFIGS/cron.jobs

# make a backup of polish keyboard layout
# sudo cp /usr/share/X11/xkb/symbols/pl /usr/share/X11/xkb/symbols/pl.backup

# overwrite polish keyboard layout with my own layout
# sudo cp -f $MY_CONFIGS/janek-keyboard-layout /usr/share/X11/xkb/symbols/pl

# copy my global git settings
cp $MY_CONFIGS/gitconfig ~/.gitconfig
# when git > 1.7.10 becomes widespread, this could be used instead:
# [include]
#	path = $MY_CONFIGS/gitconfig

