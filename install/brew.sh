#!/bin/sh

if test ! $(which brew); then
	echo "Installing homebrew"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap caskroom/fonts

echo "Installing homebrew packages..."

formulas=(
    # flags should pass through the the `brew list check`
    'macvim --with-override-system-vim'
    ack
    caskroom/cask/brew-cask
    diff-so-fancy
    dnsmasq
    fzf
    git
    'grep --with-default-names'
    highlight
    hub
    irssi
    markdown
    neovim/neovim/neovim
    nginx
    nvm
    reattach-to-user-namespace
    the_silver_searcher
    tmux
    tree
    rbenv
    ruby-build
    watchman
    wget
    z
    zsh
)

for formula in "${formulas[@]}"; do
    if brew list "$formula" > /dev/null 2>&1; then
        echo "$formula already installed... skipping."
    else
        brew install $formula
    fi
done
