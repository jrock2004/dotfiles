#!/bin/bash

# If Bash on Windows, we need to add another repo to get correct PHP version
if [[ "$(< /proc/version)" == *"Microsoft"* || "$(< /proc/sys/kernel/osrelease)" == *"Microsoft"* ]]; then
    sudo add-apt-repository ppa:ondrej/php

    sudo apt-get update
fi

sudo apt-get -y install php-cli unzip php-mysql php-mcrypt php-mbstring php-xml php-zip php-sqlite3 sqlite3 libsqlite3-dev


curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chown -R jcostanzo:jcostanzo $HOME/.composer

# Link the composer.json file
ln -s $HOME/.dotfiles/composer/composer.json $HOME/.composer/

# Cleanup
rm composer-setup.php

# Install Laravel
/usr/local/bin/composer global require "laravel/installer"
