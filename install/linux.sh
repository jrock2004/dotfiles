#!/bin/bash

### Method is used to see if command exists on your system
command_exists() {
	type "$1" > /dev/null 2>&1
}

# Sources for Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Sources for .net core
sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ yakkety main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893

# Sources for Mono
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list

# Sources for Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# Sources for OBS
sudo apt-add-repository ppa:obsproject/obs-studio

# Sources for Docker
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list

# Sources for Virtualbox
wget -q -O - http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list.d/virtualbox.list'

# Sources for Neofetch
sudo add-apt-repository ppa:dawidd0811/neofetch

# Sources for Openshot
sudo add-apt-repository ppa:openshot.developers/ppa

# Sources for Albert
sudo add-apt-repository ppa:flexiondotorg/albert

# Sources for Ruby
sudo apt-add-repository ppa:brightbox/ruby-ng

# Sources for Wine
sudo add-apt-repository ppa:wine/wine-builds

# Sources for Nvidia drivers
sudo add-apt-repository ppa:graphics-drivers/ppa

# Lets updated so we can get new sources
sudo apt-get update

sudo apt-get install -y bash-completion vim vim-scripts python-dev python-pip \
	python3-dev python3-pip neovim build-essential ack-grep tree wget nginx \
	tmux markdown irssi irssi-scripts zsh xclip cmake mono-complete \
	exuberant-ctags dconf-tools firefox-dev spotify-client ffmpeg obs-studio \
	apt-transport-https ca-certificates linux-image-extra-$(uname -r) \
	linux-image-extra-virtual docker docker-compose virtualbox autoconf bison \
	libssl-dev libreadline-dev zlib1g-dev neofetch openshot-qt albert wallch \
	ruby2.3 ruby2.3-dev ruby-switch zlibc zlib1g-dev libxml2 libxml2-dev \
	libxslt1.1 libxslt1-dev silversearcher-ag ngrep highlight winehq-staging \
	winetricks chromium-browser chromium-codecs-ffmpeg-extra plymouth-x11

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
