#!/usr/bin/env bash

DOTFILES="$(pwd)"

command_exists() {
	type "$1" /dev/null 2>&1
}

seperator() {
	echo -e "==============================\n"
}

get_linkables() {
	find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

link() {
	echo -e "\nCreating symlinks"
	seperator

	if [ ! -e "$HOME/.dotfiles" ]; then
		echo "Adding symlink to dotfiles at $HOME/.dotfiles"
		ln -s "$DOTFILES" ~/.dotfiles
	fi

	for file in $(get_linkables) ; do
		target="$HOME/.$(basename "$file" '.symlink')"
		if [ -e "$target" ]; then
			echo "~${target#$HOME} already exists... Skipping."
		else
			echo "Creating symlink for $file"
			ln -s "$file" "$target"
		fi
	done

	echo -e "\n\ninstalling to ~/.config"
	seperator
	if [ ! -d "$HOME/.config" ]; then
		echo "Creating ~/.config"
		mkdir -p "$HOME/.config"
	fi

	config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)
	for config in $config_files; do
		target="$HOME/.config/$(basename "$config")"
		if [ -e "$target" ]; then
			echo "~${target#$HOME} already exists... Skipping."
		else
			echo "Creating symlink for $config"
			ln -s "$config" "$target"
		fi
	done
}

homebrew() {
	echo -e "\nSetting up Homebrew"
	seperator

	if test ! "$(command -v brew)"; then
		echo -e "Homebrew not installed. Installing."
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
		echo -e "\nInstalling fzf"
		"$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
	}

shell() {
	echo -e "\nSetting up Fish"
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

stow() {
	stow --restow --ignore ".DS_Store" --target="$(HOME)" --dir="$(DOTFILES)" files
}

zolta() {
	curl https://get.volta.sh | bash -s -- --skip-setup
}

neovim() {
	python3 -m pip install --upgrade pynvim
}

zplug() {
	git clone https://github.com/zplug/zplug.git ~/.zplug
}

createDir() {
	echo -e "\nCreating some directories we use"
	seperator

	mkdir -p ~/Development
}

case "$1" in
	link)
		link
		;;
	brew)
		homebrew
		;;
	shell)
		shell
		;;
	createDir)
		createDir
		;;
	stow)
		stow
		;;
	zolta)
		zolta
		;;
	neovim)
		neovim
		;;
	zplug)
		zplug
		;;
	all)
		brew
		stow
		zolta
		neovim
		shell
		createDir
		;;
	*)
		echo $"Usage: $(basename "$0") {link|brew|shell|createDir|stow|zolta|neovim|zplug|all}"
		exit 1
		;;
esac

