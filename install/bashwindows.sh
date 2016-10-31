#!/bin/bash

echo "Lets install our Linux Stuff"

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo apt-get install -y bash-completion vim vim-scripts python-dev python-pip python3-dev python3-pip neovim build-essential nodejs npm ack-grep tree wget nginx ruby-build tmux mardown irssi irssi-scripts zsh

# Fixes
sudo ln -s /usr/bin/nodejs /usr/bin/node

# Install some extra tools
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/bin/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/bin/zsh-autosuggestions

curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o $HOME/bin/git-completion.zsh

sudo cp -a $HOME/bin/zsh-syntax-highlighting /usr/local/share
sudo cp -a $HOME/bin/zsh-autosuggestions /usr/local/share
sudo cp -a $HOME/bin/git-completion.zsh /usr/local/share

rm -Rf $HOME/bin/zsh-syntax-highlighting
rm -Rf $HOME/bin/zsh-autosuggestions
rm -Rf $HOME/bin/git-completion.zsh

mkdir -p $HOME/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build