#!/bin/bash

sudo pacman -S gnome xf86-video-intel networkmanager network-manager-applet
sudo systemctl enable gdm
sudo systemctl disable dhcpcd
sudo systemctl enable NetworkManager
sudo echo "noarp" >> /etc/dhcpcd.conf
sudo pacman -S vim nodejs npm neovim python2 python2-pip firefox zsh skype tmux openssh ruby
yaourt -S google-chrome rbenv
