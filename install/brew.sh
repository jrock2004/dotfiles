#!/bin/sh

if test ! $(which brew); then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing homebrew packages..."

# cli tools
brew install ack
brew install tree
brew install wget
brew install caskroom/cask/brew-cask
brew install node
brew install watchman
brew install ngrep

# development server setup
brew install nginx
brew install dnsmasq

# development tools
brew install git
brew install hub
#brew install macvim --with-override-system-vim
brew install reattach-to-user-namespace
brew install tmux
brew install zsh
brew install highlight
brew install z
brew install markdown

# install neovim
brew tap neovim/neovim
brew install --HEAD neovim

# communication tools
brew install irssi
