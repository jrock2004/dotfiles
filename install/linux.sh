#!/bin/bash

OS=$(lsb_release -si)

echo "Add some external sources"

if [ "$OS" = "elementary" ]; then
    # Need to install add-apt-repository
    sudo apt-get install -y software-properties-common
    source ~/.bashrc
fi

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

# Lets updated so we can get new sources
sudo apt-get update

sudo apt-get install -y bash-completion vim vim-scripts python-dev python-pip \
python3-dev python3-pip neovim build-essential ack-grep tree wget nginx tmux \
markdown irssi irssi-scripts zsh xclip cmake mono-complete exuberant-ctags \
dconf-tools firefox-dev spotify-client ffmpeg obs-studio apt-transport-https \
ca-certificates linux-image-extra-$(uname -r) linux-image-extra-virtual docker \
docker-compose virtualbox autoconf bison libssl-dev libreadline-dev zlib1g-dev \
neofetch openshot-qt albert wallch ruby2.3 ruby2.3-dev ruby-switch zlibc \
zlib1g-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev

# Install some extra tools
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install

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

if [ "$OS" = "elementary" ]; then
    # Install dropbox
    git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox/tmp/elementary-dropbox/install.sh
fi

# Install Visual Studio code
curl -o $HOME/bin/code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg -i $HOME/bin/code.deb

rm -Rf $HOME/bin/code.deb

# Fix installs
sudo apt-get -f install

# Setup groups
sudo groupadd docker
sudo usermod -aG docker $USER


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
gsettings set org.gnome.FileRoller.FileSelector show-hidden true

# Settings specific for Ubuntu
if [ "$OS" = "Ubuntu" ]; then
    # Set screenshot settings
    gsettings set org.gnome.gnome-screenshot default-file-type jpg

    # Set auto timezone
    gsettings set org.gnome.desktop.datetime automatic-timezone true

    # Set battery percentage
    gsettings set org.gnome.desktop.interface show-battery-percentage true
fi

# Settings specific for ElementaryOS
if [ "$OS" = "elementary" ]; then
    # Lock on lid close
    gsettings set apps.light-locker lock-on-lid true

    # Set screenshot settings
    gsettings set net.launchpad.screenshot format jpg

    # Mouse Settings
    gsettings set org.gnome.settings-daemon.peripherals.mouse locate-pointer true

    # Battery Settings
    gsettings set org.pantheon.desktop.wingpanel.indicators.power show-percentage true

    # Pant Files Settings
    gsettings set org.pantheon.files.preferences single-click false

    # Scratch
    gettings set org.pantheon.scratch.settings auto-indent true
    gettings set org.pantheon.scratch.settings autosave false
    gettings set org.pantheon.scratch.settings highlight-current-line true
    gettings set org.pantheon.scratch.settings show-right-margin true

    # Unsafe paste alert
    gettings set org.pantheon.terminal.settings unsafe-paste-alert false
fi;
