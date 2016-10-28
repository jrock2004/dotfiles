#!/bin/sh

echo -e "\n\nInstalling Node (from nvm)"
echo "=============================="

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash


# reload nvm into this environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

nvm install stable
nvm alias default stable
