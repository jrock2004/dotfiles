#!/usr/bin/env bash

sudo apt-get install \
  ack \
  alacritty \
  bat \
  cabextract \
  cloc \
  cmake \
  dconf-editor \
  discord \
  exa \
  fd-find \
  fzf \
  gcc \
  gh \
  git \
  gnupg \
  grep \
  htop \
  jq \
  kitty \
  libx11-dev \
  libxinerama-dev \
  libxft-dev \
  luarocks \
  make \
  markdown \
  neofetch \
  ninja-build \
  python2-dev \
  python3-dev \
  python3-pip \
  qemu \
  ripgrep \
  shellcheck \
  stow \
  tmux \
  tree \
  vim \
  virt-manager \
  wget \
  sel \
  zsh


# 1Password

curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22

curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22

curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

sudo apt update && sudo apt install 1password

# Golang
curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz
rm go1.16.7.linux-amd64.tar.gz

# Starship
curl -sS https://starship.rs/install.sh | sh

# Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz
rm lazygit
rm -Rf ~/.config/lazygit
