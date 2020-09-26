#!/usr/bin/env bash

# Variables

DOTFILES="$(pwd)"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Helper functions

# Generates colored output.
function special_echo {
  # echo -e '\E[0;32m'"$1\033[0m"
	echo -e "$1"
}

error_echo() {
  echo -e '\E[0;31m'"$1\033[0m"
}

command_exists() {
	type "$1" /dev/null 2>&1
}

seperator() {
	echo -e "==============================\n"
}

get_linkables() {
	find -H "$DIR" -maxdepth 3 -name '*.symlink'
}

# Functions to execute to do things

setup_init() {
	if [ "$(uname)" == "Darwin" ]; then
		special_echo "Setting up dotfiles on your mac"
	elif  [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		special_echo "Setting up dotfiles on your linux machine"
	fi

	seperator
}

setup_symlinks() {
	special_echo "Creating symlinks"
	seperator

	if [ ! -e "$DIR/.dotfiles" ]; then
		special_echo "Adding symlink to dotfiles at $DIR/.dotfiles"
		ln -s "$DIR" ~/.dotfiles
	fi

	for file in $(get_linkables) ; do
		target="$DIR/.$(basename "$file" '.symlink')"
		if [ -e "$target" ]; then
			special_echo "~${target#$DIR} already exists... Skipping."
		else
			special_echo "Creating symlink for $file"
			ln -s "$file" "$target"
		fi
	done

	special_echo "installing to ~/.config"
	seperator

	if [ ! -d "$DIR/.config" ]; then
		special_echo "Creating ~/.config"
		mkdir -p "$DIR/.config"
	fi

	config_files=$(find "$DIR/config" -maxdepth 1 2>/dev/null)
	for config in $config_files; do
		target="$DIR/.config/$(basename "$config")"
		if [ -e "$target" ]; then
			special_echo "~${target#$DIR} already exists... Skipping."
		else
			special_echo "Creating symlink for $config"
			ln -s "$config" "$target"
		fi
	done
}

setup_homebrew() {
	special_echo "Setting up Homebrew"
	seperator

	if test ! "$(command -v brew)"; then
		special_echo "Homebrew not installed. Installing."

		# Run as a login shell (non-interactive) so that the script doesn't pause for user input
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
	fi

	if [ "$(uname)" == "Linux" ]; then
		test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
	fi

	# install brew dependencies from Brewfile
	brew bundle

	# install fzf
	special_echo "Installing fzf"
	"$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

setup_shell() {
	special_echo "Setting up Fish"
	seperator

	fish_path="$( command -v fish )"

	if ! grep "$fish_path" /etc/shells; then
		echo "Adding fish to /etc/shells"
		echo "$fish_path" | sudo tee -a /etc/shells
	fi

	if [[ "#SHELL" != "$fish_path" ]]; then
		chsh -s "$fish_path"
		echo "default shell changed to $fish_path"
	fi
}

setup_stow() {
	stow --restow --ignore ".DS_Store" --target="$HOME" --dir="$DIR" files
}

setup_zolta() {
	curl https://get.volta.sh | bash -s -- --skip-setup
}

setup_neovim() {
	if [ "$(uname)" == "Linux" ]; then
		sudo apt-get update
		sudo apt-get install python3-pip
		
		python3 -m pip install --upgrade pynvim
	else
		python -m pip install --upgrade pynvim
	fi
}

setup_zplug() {
	git clone https://github.com/zplug/zplug.git ~/.zplug
}

createDir() {
	special_echo "Creating some directories we use"
	seperator

	mkdir -p ~/Development
}

case "$1" in
	link)
		setup_symlinks
		;;
	brew)
		setup_homebrew
		;;
	shell)
		setup_shell
		;;
	createDir)
		createDir
		;;
	stow)
		setup_stow
		;;
	zolta)
		setup_zolta
		;;
	neovim)
		setup_neovim
		;;
	zplug)
		setup_zplug
		;;
	init)
		setup_init
		;;
	all)
		setup_init
		setup_homebrew
		setup_stow
		setup_zolta
		setup_neovim
		setup_shell
		createDir
		;;
	*)
		special_echo $"Usage: $(basename "$0") {link|brew|shell|createDir|stow|zolta|neovim|zplug|all}"
		exit 1
		;;
esac

