# this script is intended to be used for configuring
# my system and user account.
# it's meant to be ran once, not with everys system reboot.

# a program for changing line endings from windows to unix
sudo apt-get install flip

# a program for changing screen brightness
sudo apt-get install xbacklight

# a program for opening files with GUI programs from command line (gnome-open)
sudo apt-get install libgnome2-0

# TODO install gimp
# TODO install imagemagick
# TODO install frescobaldi
# TODO configure user dirs
# TODO decide and install some txt editor
# TODO change keyboard sensitivity

echo " " | tee -a $HOME/.bashrc
echo 'export JANEKDATA=$HOME/Desktop' | tee -a $HOME/.bashrc
echo 'export bashsettings=$JANEKDATA/moje/cli/config' | tee -a $HOME/.bashrc
echo 'source $bashsettings/bash-settings.sh' | tee -a $HOME/.bashrc

# create an .inputrc file and link to the content
echo '$include ~/jw/janek/moje/cli/config/inputrc' | tee -a $HOME/.inputrc

# make bash autocompletion case-insensitive:
echo set completion-ignore-case on | sudo tee -a /etc/inputrc

# load my cron jobs
crontab $bashsettings/cron.jobs

# make a backup of polish keyboard layout
sudo cp /usr/share/X11/xkb/symbols/pl /usr/share/X11/xkb/symbols/pl.backup

# overwrite polish keyboard layout with my own layout
sudo cp -f $bashsettings/janek-keyboard-layout /usr/share/X11/xkb/symbols/pl

# copy my global git settings
cp $bashsettings/gitconfig ~/.gitconfig
# when git > 1.7.10 becomes widespread, this could be used instead:
# [include]
#	path = ~/janek/moje/cli/git/gitconfig

