#!/usr/bin/env sh

echo "only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo "expand save dialog by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "show the ~/Library folder in Finder"
chflags nohidden ~/Library

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Use current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Show Status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

echo "Enable tap to click (Trackpad)"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

echo "Lets install the apps we need"

echo "Installing pip"
sudo easy_install pip

brew tap caskroom/versions

echo "Installing Google Chrome"
brew cask install google-chrome

echo "Installing 1Password"
brew cask install 1password

echo "Installing Alfred"
brew cask install alfred

echo "Installing Bartender"
brew cask install bartender

echo "Installing Dropbox"
brew cask install dropbox

echo "Installing Firefox"
brew cask install firefox

echo "Installing iTerm"
brew cask install iterm2

#echo "Installing Office"
#brew cask install microsoft-office

echo "Installing Parallels"
brew cask install parallels-desktop

echo "Installing Skype"
brew cask install skype

echo "Installing Slack"
brew cask install slack

echo "Installing Spotify"
brew cask install spotify

echo "Installing Java"
brew cask install java

echo "Install Sublime Text 3"
brew cask install sublime-text3

echo "Install Spectacle"
brew cask install Spectacle

echo "Install Twitch"
brew cask install twitch

echo "Install iShowU HD"
brew cask install ishowu-hd
