#!/bin/bash

echo "Lets install our Linux Stuff"

# Sources for Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Sources for .net core
sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893
# Sources for Mono
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list

# Lets updated so we can get new sources
sudo apt-get update

sudo apt-get install -y bash-completion vim vim-scripts python-dev python-pip python3-dev python3-pip neovim build-essential ack-grep tree wget nginx tmux markdown irssi irssi-scripts zsh xclip cmake mono-complete exuberant-ctags

# Install some extra tools
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/bin/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/bin/zsh-autosuggestions

sudo cp -a $HOME/bin/zsh-syntax-highlighting /usr/local/share
sudo cp -a $HOME/bin/zsh-autosuggestions /usr/local/share

rm -Rf $HOME/bin/zsh-syntax-highlighting
rm -Rf $HOME/bin/zsh-autosuggestions

# Lets install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
mkdir -p $HOME/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
