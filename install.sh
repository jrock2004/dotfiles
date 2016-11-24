#!/bin/bash

# Setting up some variables
EMAIL="jrock2004@gmail.com"
DEVFOLDER="$HOME/Development"
NPMFOLDER="$HOME/.npm-packages"

echo "Symlinking dotfiles"
source install/link.sh

echo "Creating needed directories"
mkdir -p $DEVFOLDER
mkdir -p $NPMFOLDER

source install/brew.sh
source install/osx.sh
source install/nvm.sh
source install/python.sh
source install/node.sh

echo "Configuring nginx"
mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.original
ln -s ~/.dotfiles/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

echo "Installing Node Apps"
source install/node.sh

echo "Installing and setting Ruby version"
rbenv install 2.2.3
rbenv global 2.2.3

echo "Installing some Gems"
gem install scss_lint
gem install rails
rbenv rehash

echo "Configuring zsh as default shell"
chsh -s $(which zsh)

echo "Done."
