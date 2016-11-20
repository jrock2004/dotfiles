#!/bin/bash

sudo apt-get -y install php5-cli unzip php5-mysql php5-mcrypt

curl -sS https://getcomposer.org/installer -o composer-setup.php

sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

sudo chown -R jcostanzo:jcostanzo $HOME/.composer

rm composer-setup.php
