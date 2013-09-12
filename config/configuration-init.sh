#!/bin/bash
# configure my user.

die() {
    echo -en "\e[00;31m$1\e[00m"
    exit 1
}

# install latest version of git
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git || die "Failed to install git."
echo "Successfully installed $(git --version)"
echo ""
sleep 2

# clone my repository with scripts and configs
cd $HOME
git clone https://github.com/janek-warchol/cli-tools.git \
~/repos/cli-tools/ || die "Failed to clone cli-tools."

echo 'export ALL_MY_STUFF=$HOME' | tee -a $HOME/.bashrc
echo 'export MY_CONFIGS=$ALL_MY_STUFF/repos/cli-tools/config' | tee -a $HOME/.bashrc
echo 'source $MY_CONFIGS/bash-settings.sh' | tee -a $HOME/.bashrc
sleep 2

echo "Copying my configs..."
~/repos/cli-tools/system-config-copy-settings.sh || "Failed to copy configs."
echo "done."
sleep 2

echo "Installing software..."
~/repos/cli-tools/system-config-install-software.sh
echo "done."
sleep 2

echo "Goodbye!"
rm $0
