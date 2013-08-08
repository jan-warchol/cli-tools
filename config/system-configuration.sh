# this script is intended to be used for configuring
# my system and user account.
# it's meant to be ran once, not with everys system reboot.

# color definitions
red="\e[00;31m"
normal="\e[00m"

die() {
    # in case of some error...
    echo -e "$red$1$normal"
    echo Exiting.
    exit 1
}

# create an .inputrc file and link to the content
echo '$include $MY_CONFIGS/inputrc' | tee -a $HOME/.inputrc

# remap CAPS LOCK to another Control
/usr/bin/setxkbmap -option "ctrl:nocaps"

# make bash autocompletion case-insensitive:
echo set completion-ignore-case on | sudo tee -a /etc/inputrc

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


##############################################
# SOFTWARE INSTALLATION:
# note that this is at the end of the script so that any
# errors don't stop too much work.

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

# TODO install frescobaldi
