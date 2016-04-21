#!/bin/bash

# Setting up some variables
EMAIL="jrock2004@gmail.com"
DEVFOLDER="~/Development"
OS=""

echo "Symlinking dotfiles"
source install/link.sh

if [ "$(uname)" == "Linux" ]; then
	echo "Running Linux"

	# Set up SSH keys
	while true; do
		read -p "Copy your key to github: " yn
		case $yn in
			[Yy]* )
				ssh-keygen -t rsa -b 4096 -C $EMAIL
				eval "$(ssh-agent -s)"
				ssh-add ~/.ssh/id_rsa
				xclip -sel clip < ~/.ssh/id_rsa.pub
				break
				;;
			[Nn]* )
				break
				;;
		esac
	done
fi

if [ "$(uname)" == "Darwin" ]; then
	echo "Running OSX"

	# Set up SSH keys
	while true; do
		read -p "Copy your key to github: " yn
		case $yn in
			[Yy]* )
				ssh-keygen -t rsa -b 4096 -C $EMAIL
				eval "$(ssh-agent -s)"
				ssh-add ~/.ssh/id_rsa
				pbcopy < ~/.ssh/id_rsa.pub
				break
				;;
			[Nn]* )
				break
				;;
		esac
	done
fi

if [ "$(uname)" == "Darwin" ]; then
	echo "Brewing all the things"
	source install/brew.sh

	echo "Updating OSX settings"
	source install/osx.sh

	echo "Configuring nginx"
	mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.original
	ln -s ~/.dotfiles/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf
fi

if [ "$(uname)" == "Linux" ]; then
	# Lets get the linux distro
	OS=$(cat /etc/os-release | grep -sw NAME)
	NEWOS=$(echo "$OS" | cut -d \" -f2)
	
	case "$NEWOS" in
		*Arch*)
			source install/arch.sh
			;;
		*Ubuntu*)
			source install/debian.sh
			;;
	esac
fi

echo "Creating needed directories"
mkdir -p $DEVFOLDER

echo "Installing Node Apps"
source install/node.sh

echo "Install some Python stuff"
source install/python.sh

echo "Installing and setting Ruby version"
rbenv install 2.2.3
rbenv global 2.2.3

echo "Installing some Gems"
sudo gem install scss_lint
sudo gem install rails
rebenv rehash



echo "Now setting up your mac"
if [ "$(uname)" == "Darwin" ]; then

fi

echo "Now setting up your linux"
if [ "$(uname)" == "Linux" ]; then

fi

echo "Configuring zsh as default shell"
chsh -s $(which zsh)

echo "Done."
