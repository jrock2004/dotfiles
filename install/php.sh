#!/bin/bash

curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chown -R jcostanzo:jcostanzo $HOME/.composer

# Link the composer.json file
echo "{}" > $HOME/.composer/composer.json

# Cleanup
rm composer-setup.php

# Install Laravel
/usr/local/bin/composer global require "laravel/installer"
