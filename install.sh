#!/usr/bin/env bash

#### Variables ####

BIN="$HOME/bin"
DEVFOLDER="$HOME/Development"
OS=''

###################

#### Functions ####

# A function to check if a command exists
command_exists() {
	type "$1" > /dev/null 2>&1
}

###################

# Ask the user what OS they are running instead of trying to guess
PS3='Which OS are you running: '
options=("Apple" "Linux" "Pi" "Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Apple")
			OS="apple"
			break
			;;
		"Linux")
			OS="linux"
			break
			;;
		"Pi")
			OS="pi"
			break
			;;
			;;
		"Quit")
			exit 0
			break
			;;
		*) echo invalid option;;
	esac
done

# Create some directories
echo -e "\\n\\nCreating some default directories that we will be using"
mkdir -p "$BIN"
mkdir -p "$DEVFOLDER"

if [ "$OS" = "apple" ]; then
	if test ! "$( command -v brew )"; then
		echo -e "\\n\\nInstalling homebrew"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	make apple
elif [ "$OS" = "linux" ]; then
	if test ! "$( command -v brew )"; then
		echo -e "\\n\\nInstalling homebrew"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
	test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

	make linux
elif [ "$OS" = "pi" ]; then
	make pie
else
		echo -e "\\n\\nCould not detect OS/distro. Stopping execution"
		exit 0
fi

# Setting env to zsh instead of bash
echo -e "\\n\\nSwitching to ZSH"
if ! command_exists zsh; then
	echo -e "\\n\\nzsh not found. Please install and then re-run installation scripts"
	exit 1
elif ! command_exists fish; then
	echo -e "\\n\\nfish not found. Please install and then re-run installation scripts"
	exit 1
fi

zsh_path="$( command -v zsh )"
fish_path="$( command -v fish )"

if ! grep "$zsh_path" /etc/shells; then
	echo "$zsh_path" | sudo tee -a /etc/shells
fi
	
if ! grep "$fish_path" /etc/shells; then
	echo "$fish_path" | sudo tee -a /etc/shells
fi

chsh -s "$fish_path"

echo -e "\\n\\nInstaller is done. Log out and log back in again to get changes"
