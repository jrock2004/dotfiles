#!/bin/bash

sudo echo "[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch" >> /etc/pacman.conf

sudo echo "[testing]
Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

sudo echo "[multilib]
Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

sudo pacman -Sy

sudo pacman -S gnome xf86-video-intel networkmanager network-manager-applet
sudo systemctl enable gdm
sudo systemctl disable dhcpcd
sudo systemctl enable NetworkManager
sudo echo "noarp" >> /etc/dhcpcd.conf
sudo pacman -S vim nodejs npm neovim python2 python2-pip firefox zsh skype tmux openssh ruby
yaourt -S google-chrome rbenv