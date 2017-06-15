#!/usr/bin/env bash

command_exists() {
	type "$1" > /dev/null 2>&1
}

# Setting up some variables
EMAIL="jrock2004@gmail.com"
DEVFOLDER="$HOME/Development"
DOWNLOADS="$HOME/Downloads"
BIN="$HOME/bin"

# Symlinking dotfiles to home dir
source install/link.sh

# Creating needed directories
mkdir -p $DEVFOLDER
mkdir -p $BIN
mkdir -p $DOWNLOADS

# Installing the apps that we need
source install/linux.sh

# Installing some python modules
source install/python.sh

# Installing Node Apps
source install/yarn.sh

# Installing Ruby stuff
source install/ruby.sh

# Installing Fonts
source install/fonts.sh

# Installing PHP stuff
source install/php.sh

# installing resource files
tic $HOME/.dotfiles/resources/xterm-256color-italic.terminfo
tic $HOME/.dotfiles/resources/tmux-256color-italic.terminfo

# Setup SSH key if needed
if [ ! -d ~/.ssh ]; then
	mkdir ~/.ssh
fi

if [ ! -f ~/.ssh/id_rsa.pub  ]; then
	ssh-keygen -t rsa -b 4096 -C "$EMAIL"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa

	GITHUB_SSH_URL=https://github.com/settings/ssh

	if command_exists xdg-open; then
		xdg-open $GITHUB_SSH_URL
	else
		echo $GITHUB_SSH_URL
	fi

	cat $HOME/.ssh/id_rsa.pub

	read -p "`echo $'\n\n'` Hit ENTER after adding to Github `echo $'\n\n'`"
else
	echo ".ssh directory already exists, not generating"
fi

if ! command_exists zplug; then
	echo "installing zplug, a plugin manager for zsh - http://zplug.sh"
	# curl -sL zplug.sh/installer | zsh
	git clone https://github.com/zplug/zplug.git ~/.zplug
fi

# Setting env to zsh instead of bash
echo "Switching to ZSH"
if ! command_exists zsh; then
	echo "zsh not found. Please install and then re-run installation scripts"
	exit 1
elif ! [[ $SHELL =~ .*zsh.* ]]; then
	echo "Configuring zsh as default shell"
	chsh -s $(which zsh)
fi

echo "Done. Close window and re-open to enjoy"
