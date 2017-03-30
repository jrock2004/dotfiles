#!/bin/bash

# Setup ruby
$HOME/.rbenv/bin/rbenv install 2.3.4
$HOME/.rbenv/bin/rbenv global 2.3.4

echo 'eval "$(rbenv init -)"' >> ~/.bashrc

echo "Installing some Gems"
gem install bundler
gem install scss_lint
gem install rails --pre
gem install neovim
