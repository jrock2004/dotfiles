#!/bin/bash
echo "Installing and setting Ruby version"
ruby-switch --set ruby2.3

echo "Installing some Gems"
gem install bundler
gem install scss_lint
gem install rails --pre
