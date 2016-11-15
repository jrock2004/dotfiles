#!/bin/bash
echo "Installing and setting Ruby version"
$HOME/.rbenv/bin/rbenv install 2.2.3
$HOME/.rbenv/bin/rbenv global 2.2.3

echo "Installing some Gems"
gem install scss_lint
gem install rails
rbenv rehash
