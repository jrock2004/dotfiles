#!/bin/bash

# Setting up some variables
EMAIL="jrock2004@gmail.com"
NPMFOLDER="$HOME/.npm-packages"
BIN="$HOME/bin"

echo "Symlinking dotfiles"
source install/link.sh

echo "Creating needed directories"
mkdir -p $NPMFOLDER
mkdir -p $BIN
# Need to do this because linux and windows are not friendly
ln -s /mnt/c/Development $HOME/Development

echo "Installing the apps that we need"
source install/bashwindows.sh

source $HOME/.bashrc

echo "Using nvm for better node support"
source install/nvm.sh

echo "Installing some python modules"
source install/python.sh

echo "Installing Node Apps"
source install/node.sh

echo "Installing Ruby stuff"
source install/ruby.sh

echo "Installing PHP stuff"
source install/php.sh

# Before starting lets backup the existing bashrc
mv $HOME/.bashrc $HOME/.bashrc.bak

# Setup SSH key
if [ ! -d $HOME/.ssh ]; then
    mkdir $HOME/.ssh
    chmod 700 $HOME/.ssh
    ssh-keygen -t rsa -b 4096 -C "$EMAIL"
    chmod 600 $HOME/.ssh/id_rsa
    eval "$(ssh-agent -s)"
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_rsa

    GITHUB_SSH_URL=https://github.com/settings/ssh

    cat $HOME/.ssh/id_rsa.pub
    echo
    echo $GITHUB_SSH_URL

    read -p "Hit ENTER after adding to Github"
else
    echo ".ssh directory already exists, not generating"
fi

echo "Done. Close window and re-open to enjoy"
