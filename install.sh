#!/bin/bash

echo "Installing dotfiles"

source install/link.sh

echo "Generating SSH Keys"
ssh-keygen -t rsa -b 4096 -C "jrock2004@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub

# Lets put a hold on things until we put the key in github
while true; do
	read -p "Copy your key to github" yn
	case $yn in
		[Yy]* ) break;;
	esac
done

echo "Initializing submodule(s)"
git submodule update --init --recursive


if [ "$(uname)" == "Darwin" ]; then
	echo "Running OSX"

	echo "Creating needed directories"
	mkdir -p /Users/jcostanzo/Development
	mkdir -p /Users/jcostanzo/Development/Work
	
	echo "Brewing all the things"
    source install/brew.sh

    echo "Updating OSX settings"
    source install/installosx.sh

    #echo "Installing node (from nvm)"
    #source install/nvm.sh

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
