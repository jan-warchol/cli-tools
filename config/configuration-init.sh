#!/bin/bash
# configure my user.

die() {
    echo -en "\e[00;31m$1\e[00m"
    exit 1
}

# install latest version of git
sudo add-apt-repository --yes ppa:git-core/ppa
sudo apt-get --yes update
sudo apt-get --yes install git || die "Failed to install git."
echo "Successfully installed $(git --version)"
echo ""
sleep 2

# clone my repository with scripts and configs
cd $HOME
git clone git@github.com:janek-warchol/cli-tools.git \
~/repos/cli-tools/ || die "Failed to clone cli-tools."

echo 'export ALL_MY_STUFF=$HOME' | tee -a $HOME/.bashrc
echo 'export MY_CONFIGS=$ALL_MY_STUFF/repos/cli-tools/config' | tee -a $HOME/.bashrc
echo 'source $MY_CONFIGS/bash-settings.sh' | tee -a $HOME/.bashrc
sleep 2

-rm $0
