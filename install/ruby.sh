#!/bin/bash

# Setup ruby
$HOME/.rbenv/bin/rbenv install 2.3.4
$HOME/.rbenv/bin/rbenv global 2.3.4

echo 'eval "$(rbenv init -)"' >> ~/.bashrc

echo "Installing some Gems"
$HOME/.rbenv/shims/gem install bundler
$HOME/.rbenv/shims/gem install scss_lint
$HOME/.rbenv/shims/gem install rails --pre
$HOME/.rbenv/shims/gem install neovim
