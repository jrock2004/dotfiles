#!/bin/bash

sudo apt-get -y install php-cli unzip php-mysql php-mcrypt php-mbstring php-xml

curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chown -R jcostanzo:jcostanzo $HOME/.composer

rm composer-setup.php

# Install Laravel
$HOME/.composer/vendor/bin/composer global require "laravel/installer"
