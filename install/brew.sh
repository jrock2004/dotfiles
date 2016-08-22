#!/bin/sh

if test ! $(which brew); then
	echo "Installing homebrew"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Installing homebrew packages..."

# cli tools
brew install ack
#brew install ag
brew install tree
brew install wget
brew install caskroom/cask/brew-cask
brew install watchman
#brew install ngrep

# development server setup
brew install nginx
brew install dnsmasq
brew install rbenv ruby-build

# development tools
brew install git
brew install hub
brew install fzf
brew install macvim --with-override-system-vim
brew install reattach-to-user-namespace
brew install tmux
brew install zsh
brew install highlight
brew install z
brew install markdown
brew install nvm
brew install zsh-syntax-highlighting
brew install zsh-autosuggestions
brew install diff-so-fancy

# install neovim
brew install neovim/neovim/neovim

# communication tools
brew install irssi

exit 0
