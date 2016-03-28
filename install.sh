#!/bin/bash

echo "Symlinking dotfiles"
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
if [ "$(uname)" == "Darwin" ]; then
	echo "Running OSX"

	echo "Creating needed directories"
	mkdir -p /Users/jcostanzo/Development
	mkdir -p /Users/jcostanzo/Development/Work

	echo "Brewing all the things"
	source install/brew.sh

	echo "Updating OSX settings"
	source install/osx.sh

	echo "Installing Node Apps"
	source install/node.sh

	echo "Configuring nginx"
	mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.original
	ln -s ~/.dotfiles/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf

	echo "Install some Python stuff"
	source install/python.sh

	echo "Installing some Gems"
	sudo gem install scss_lint
fi

echo "Configuring zsh as default shell"
chsh -s $(which zsh)

echo "Done."
