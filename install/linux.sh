#!/bin/bash

### Method is used to see if command exists on your system
command_exists() {
	type "$1" > /dev/null 2>&1
}

sudo pacman -S --noconfirm bash-completion vim python python-pip neovim \
python-neovim python2-neovim ack tree wget nginx tmux markdown irssi zsh \
xclip cmake mono firefox extra/ffmpeg obs-studio autoconf bison \
community/openshot ngrep highlight winetricks virtualbox docker-compose \
libffi libyaml openssl zlib composer clang

gpg --recv-keys --keyserver hkp://pgp.mit.edu D9C4D26D0E604491
gpg --recv-keys --keyserver hkp://pgp.mit.edu 5CC908FDB71E12C2

yaourt -Sy spotify silver-searcher-git visual-studio-code dropbox \
nautilus-dropbox libopenssl-1.0-compat libcurl-openssl-1.0 lib32-libldap \
lib32-gnutls

# Install some extra tools
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install

# Setup groups
sudo usermod -aG docker $USER

# Install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
mkdir -p $HOME/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build

# Get Tmux spotify client
sudo curl https://raw.githubusercontent.com/jrock2004/tmux-spotify/master/tmux-spotify -o /usr/local/bin/tmux-spotify

sudo chmod +x /usr/local/bin/tmux-spotify

# Setting some dconf settings

# Set clock
gsettings set org.gnome.desktop.interface clock-format 12h

# Touchpad settings
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Screensaver settings
gsettings set org.gnome.desktop.screensaver lock-enabled true

# Nautilus settings
gsettings set org.gnome.nautilus.preferences show-hidden-files true

# File roller Settings
gsettings set org.gnome.file-roller.file-selector show-hidden true

# Set screenshot settings
gsettings set org.gnome.gnome-screenshot default-file-type jpg

# Set auto timezone
gsettings set org.gnome.desktop.datetime automatic-timezone true

