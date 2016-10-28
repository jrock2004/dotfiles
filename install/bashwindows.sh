#!/bin/bash

echo "Lets install our Linux Stuff"

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo apt-get install -y bash-completion vim vim-scripts python-dev python-pip
sudo apt-get install -y python3-dev python3-pip neovim build-essential
sudo apt-get install -y nodejs npm ack-grep tree wget nginx rbenv ruby-build
sudo apt-get install -y tmux mardown irssi irssi-scripts

# Fixes
sudo ln -s /usr/bin/nodejs /usr/bin/node

# Install some extra tools
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/bin/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/bin/zsh-autosuggestions

curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o !/bin/git-completion.zsh

sudo cp -a ~/bin/zsh-syntax-highlighting /usr/local/share
sudo cp -a ~/bin/zsh-autosuggestions /usr/local/share
sudo cp -a ~/bin/git-completion.zsh /usr/local/share

rm -Rf ~/bin/zsh-syntax-highlighting
rm -Rf ~/bin/zsh-autosuggestions
rm -Rf ~/bin/git-completion.zsh
