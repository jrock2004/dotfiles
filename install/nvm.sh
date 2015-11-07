#!/bin/sh

# reload nvm into this environment
source $(brew --prefix nvm)/nvm.sh

nvm install stable
nvm alias default stable

echo "Install the node packages I need"
npm install -g gulp bower browser-sync yo nodemon express express-generator
