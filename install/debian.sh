#!/bin/bash

echo "Lets install our Linux Stuff"

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" >> /etc/apt/sources.list.d/docker.list

Apps to install
sudo apt-get install -y vim
sudo apt-get install -y vim-scripts
sudo apt-get install -y python-dev python-pip python3-dev python3-pip
sudo apt-get install -y neovim
sudo apt-get install -y build-essential
sudo apt-get install -y nodejs
sudo apt-get install -y npm
sudo apt-get install -y docker docker-compose docker-engine

# Fixes
sudo ln -s /usr/bin/nodejs /usr/bin/node
