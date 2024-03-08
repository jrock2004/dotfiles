#!/bin/bash

if [ -z "$(command -v git)" ]; then
    echo "You need to install command line tools"

    sudo xcode-select --install

    echo "After installing command line tools, run this script again"

    exit 1
fi

# Check if .dotfiles exists in the home directory
if [ -d ~/.dotfiles ]; then
    echo "Dotfiles already exists in the home directory. Remove it and run this script again"

    exit 1
else
    git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles
fi

cd "$HOME"/.dotfiles || exit

exec ./install.sh
