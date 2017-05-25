#!/bin/bash

sudo apt-get -y install php-cli unzip php-mysql php-mcrypt php-mbstring \
php-xml php-zip php-sqlite3 sqlite3 libsqlite3-dev

curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

if [ ! -d ~/.composer ]; then
	mkdir ~/.composer
fi

sudo chown -R jcostanzo:users $HOME/.composer

# Link the composer.json file
echo "{}" > $HOME/.composer/composer.json

# Cleanup
rm composer-setup.php

# Install Laravel
/usr/local/bin/composer global require "laravel/installer"
