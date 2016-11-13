#!/bin/bash
echo "Installing and setting Ruby version"
rbenv install 2.2.3
rbenv global 2.2.3

echo "Installing some Gems"
gem install scss_lint
gem install rails
rbenv rehash
