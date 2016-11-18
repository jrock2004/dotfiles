#!/bin/bash

echo "Lets install our Linux Stuff"

# Need to install add-apt-repository
sudo apt-get install -y software-properties-common
source ~/.bashrc

# Sources for Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Sources for .net core
sudo sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893

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

# Lets updated so we can get new sources
sudo apt-get update

sudo apt-get install -y bash-completion vim vim-scripts python-dev python-pip python3-dev
sudo apt-get install -y python3-pip neovim build-essential ack-grep tree wget nginx tmux
sudo apt-get install -y markdown irssi irssi-scripts zsh xclip cmake
sudo apt-get install -y mono-complete exuberant-ctags dconf-tools firefox-dev spotify-client
sudo apt-get install -y ffmpeg obs-studio apt-transport-https ca-certificates 
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual docker docker-compose

# Install some extra tools
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/bin/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/bin/zsh-autosuggestions

sudo cp -a $HOME/bin/zsh-syntax-highlighting /usr/local/share
sudo cp -a $HOME/bin/zsh-autosuggestions /usr/local/share

rm -Rf $HOME/bin/zsh-syntax-highlighting
rm -Rf $HOME/bin/zsh-autosuggestions

# Lets install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
mkdir -p $HOME/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build

# Install google chrome
curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o ~/Downloads/google-chrome-stable_current_amd64.deb

sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
sudo apt-get -f install
rm ~/Downloads/google-chrome*

# Install Zoom
curl https://zoom.us/client/latest/zoom_amd64.deb -o ~/Downloads/zoom.deb
sudo dpkg -i ~/Downloads/zoom.deb
sudo apt-get -f install
rm ~/Downloads/zoom.deb

# Install slack
curl https://downloads.slack-edge.com/linux_releases/slack-desktop-2.2.1-amd64.deb -o ~/Downloads/slack.deb
sudo dpkg -i ~/Downloads/slack.deb
rm ~/Downloads/slack.deb

# Install dropbox
git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
/tmp/elementary-dropbox/install.sh

# Install Visual Studio code
curl -o $HOME/bin/code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i $HOME/bin/code.deb

rm -Rf $HOME/bin/code.deb

# Setup groups
sudo groupadd docker
sudo usermod -aG docker $USER


#### Linux settings

# Lock on lid close
gsettings set apps.light-locker lock-on-lid true

# Set screenshot settings
gsettings set net.launchpad.screenshot format jpg

# Set clock
gsettings set org.gnome.desktop.interface clock-format 12h

# Touchpad settings
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Screensaver settings
gsettings set org.gnome.desktop.screensaver lack-enabled true

# File roller Settings
gsettings set org.gnome.FileRoller.FileSelector show-hidden true

# Nautilus settings
gsettings set org.gnome.nautilus.preferences show-hidden-files true

# Mouse Settings
gsettings set org.gnome.settings-daemon.peripherals.mouse locate-pointer true

# Battery Settings
gsettings set org.pantheon.desktop.wingpanel.indicators.power show-percentage true

# Pant Files Settings
gsettings set org.pantheon.files.preferences single-click false
