#!/usr/bin/env bash

sudo apt-get install \
  ack \
  alacritty \
  bat \
  cabextract \
  clock \
  cmake \
  fd-find \
  fzf \
  gcc \
  gh \
  git \
  gnupg \
  grep \
  htop \
  jq \
  libx11-dev \
  libxinerama-dev \
  libxft-dev \
  luarocks \
  make \
  markdown \
  neofetch \
  ninja-build \
  python2-dev \
  rython3-dev \
  ripgrep \
  shellcheck \
  stow \
  tmux \
  tree \
  vim \
  wget \
  zsh


# 1Password

curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22

curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22

curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

sudo apt update && sudo apt install 1password

curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz
rm go1.16.7.linux-amd64.tar.gz

curl -sS https://starship.rs/install.sh | sh
