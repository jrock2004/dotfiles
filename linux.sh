#!/usr/bin/env bash

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo add-apt-repository ppa:lazygit-team/release
sudo apt-get update

# sudo apt-get install alacritty highlight cabextract xclip ack bat cloc cmake fzf gcc git gnupg grep htop jq luarocks make markdown ninja-build neofetch neovim python ripgrep rofi shellcheck stow tmux tree vim wget zsh

sudo apt-get install \
  alacritty \
  ack \
  bat \
  cabextract \
  cloc \
  cmake \
  fzf \
  gcc \
  git \
  gnupg \
  golang \
  grep \
  htop \
  jq \
  lazygit \
  luarocks \
  make \
  markdown \
  neofetch \
  neovim \
  ninja-build \
  python \
  ripgrep \
  shellcheck \
  stow \
  tmux \
  tree \
  vim \
  wget \
  xclip \
  zsh

# Nice prompt shell
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
