#!/bin/bash

# Setting up some variables
EMAIL="jrock2004@gmail.com"
DEVFOLDER="~/Development"
NPMFOLDER="~/.npm-packages"
BIN="~/bin"

echo "Symlinking dotfiles"
source install/link.sh


echo "Creating needed directories"
mkdir -p $DEVFOLDER
mkdir -p $NPMFOLDER
mkdir -p $BIN

echo "Installing the apps that we need"
source install/linux.sh

source ~/.bashrc

echo "Using nvm for better node support"
source install/nvm.sh

echo "Installing some python modules"
source install/python.sh

echo "Installing Node Apps"
source install/node.sh

echo "Installing Ruby stuff"
source install/ruby.sh

# Setup SSH key
if [ ! -d ~/.ssh  ]; then
    mkdir ~/.ssh
    chmod 700 ~/.ssh
    ssh-keygen -t rsa -b 4096 -C "$EMAIL"
    chmod 600 ~/.ssh/id_rsa
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
# Setup SSH key
ssh-keygen -t rsa -b 4096 -C "$EMAIL"
eval "$(ssh-agent -s)"
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# Setting env to zsh instead of bash
echo "Switching to ZSH"
chsh -s /bin/zsh

echo "Done. Close window and re-open to enjoy"
