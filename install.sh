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

echo "Installing and setting Ruby version"
rbenv install 2.2.3
rbenv global 2.2.3

echo "Installing some Gems"
gem install scss_lint
gem install rails
rbenv rehash

# Setup SSH key
ssh-keygen -t rsa -b 4096 -C "$EMAIL"
eval "$(ssh-agent -s)"
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# Setting env to zsh instead of bash
echo "Switching to ZSH"
chsh -s /bin/zsh

echo "Done. Close window and re-open to enjoy"
