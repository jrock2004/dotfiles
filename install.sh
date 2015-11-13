#!/bin/bash

echo "Installing dotfiles"

echo "Initializing submodule(s)"
git submodule update --init --recursive

source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
	echo "Running OSX"

	echo "Creating needed directories"
	mkdir -p /Users/jcostanzo/Development
	mkdir -p /Users/jcostanzo/Development/Work

	echo "Brewing all the things"
    source install/brew.sh

    echo "Updating OSX settings"
    source install/installosx.sh

    echo "Installing node (from nvm)"
    source install/nvm.sh

    echo "Configuring nginx"
    # create a backup of the original nginx.conf
    mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.original
    ln -s ~/.dotfiles/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf
    # symlink the code.dev from dotfiles
    ln -s ~/.dotfiles/nginx/sites-available/code.dev /usr/local/etc/nginx/sites-enabled/code.dev
fi

if [ "$(uname)" == "Linux" ]; then
	echo "Running Linux"

	source install/installlinux.sh
	source ~/.bashrc

	sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf-orig
	sudo ln -s ~/.dotfiles/nginx/sites-available/code-linux.dev /etc/nginx/sites-enabled/code.dev
fi

echo "Installing some node modules"
source install/node.sh

echo "Configuring zsh as default shell"
chsh -s $(which zsh)

echo "Done."
