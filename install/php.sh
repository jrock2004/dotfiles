#!/bin/bash

sudo apt-get -y install php-cli unzip php-mysql php-mcrypt php-mbstring php-xml php-zip

curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chown -R jcostanzo:jcostanzo $HOME/.composer

# Link the composer.json file
ln -s $HOME/.dotfiles/composer/composer.json $HOME/.composer/

# Cleanup
rm composer-setup.php

# Install Laravel
/usr/local/bin/composer global require "laravel/installer"
