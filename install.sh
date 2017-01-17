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

if ! command_exists zsh; then
    echo "zsh not found. Please install and then re-run installation scripts"
    exit 1
elif ! [[ $SHELL =~ .*zsh.* ]]; then
    echo "Configuring zsh as default shell"
    chsh -s $(which zsh)
fi

if ! command_exists zplug; then
    echo "installing zplug, a plugin manager for zsh - http://zplug.sh"
    # curl -sL zplug.sh/installer | zsh
    git clone git@github.com:zplug/zplug.git ~/.zplug
fi

echo "Done."
