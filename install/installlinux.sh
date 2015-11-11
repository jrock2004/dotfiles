#!/bin/sh

echo "Installing some linux apps"

echo "Adding some 3rd party repos"
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo add-apt-repository ppa:webupd8team/sublime-text-3
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt-get update

# cli tools
sudo apt-get install ack-grep
sudo apt-get install tree
sudo apt-get install wget

# servers
sudo apt-get install nginx
sudo apt-get install dnsmasq

# tools
sudo apt-get install tmux
sudo apt-get install zsh
sudo apt-get install markdown
sudo apt-get install nodejs
sudo apt-get install npm
sudo apt-get install editorconfig
sudo apt-get install python-dev python-pip python3-dev python3-pip
sudo apt-get install neovim
sudo apt-get install vim
sudo apt-get install vim-scripts
sudo apt-get install sublime-text-installer

# communication
sudo apt-get install irssi
sudo apt-get install irssi-scripts
sudo apt-get install skype

# emulation
sudo apt-get install wine
sudo apt-get install winetricks
sudo apt-get install virtualbox
sudo apt-get install virtualbox-dkms
sudo apt-get install virtualbox-guest-additions-iso

# browsers
sudo apt-get install google-chrome-stable

echo "Lets make some fixes"
source ~/.bashrc
sudo ln -s /usr/bin/nodejs /usr/bin/node
