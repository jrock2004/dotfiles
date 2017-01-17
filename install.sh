#!/bin/bash

# Setting up some variables
EMAIL="jrock2004@gmail.com"
DEVFOLDER="$HOME/Development"
BIN="$HOME/bin"

echo "Symlinking dotfiles"
source install/link.sh

echo "Creating needed directories"
mkdir -p $DEVFOLDER
mkdir -p $BIN

source install/brew.sh
source install/osx.sh
source install/nvm.sh
source install/python.sh
source install/node.sh

echo "Configuring nginx"
mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.original
ln -s $HOME/.dotfiles/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

echo "Installing Node Apps"
source install/node.sh

echo "Install Ruby"
source install/ruby.sh

echo "Configuring zsh as default shell"
chsh -s /usr/local/bin/zsh

echo "Done."
