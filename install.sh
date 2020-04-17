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
options=("Apple" "Pop" "Pi" "Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Apple")
			OS="apple"
			break
			;;
		"Pop")
			OS="linux"
			break
			;;
		"Pi")
			OS="pi"
			break
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
mkdir -p $BIN
mkdir -p $DEVFOLDER

if [ "$OS" = "apple" ]; then
	if test ! "$( command -v brew )"; then
		echo -e "\\n\\nInstalling homebrew"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	make apple
elif [ "$OS" = "linux" ]; then
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
elif ! [[ $SHELL =~ .*zsh.* ]]; then
	echo -e "\\n\\nConfiguring zsh as default shell"

	if [[ "$OS" = "apple" ]]; then
		zsh_path="$( command -v zsh )"

		if ! grep "$zsh_path" /etc/shells; then
			echo -e "\\n\\nadding $zsh_path to /etc/shells"
			echo "$zsh_path" | sudo tee -a /etc/shells
		fi

		if [[ "$SHELL" != "$zsh_path" ]]; then
			chsh -s "$zsh_path"
			echo -e "\\n\\ndefault shell changed to $zsh_path"
		fi
	elif [[ "$OS" = "linux" ]]; then
		chsh -s $(which zsh)
	else
		sudo usermod -s $(which zsh) $(whoami)
	fi
fi

echo -e "\\n\\nInstaller is done. Log out and log back in again to get changes"
