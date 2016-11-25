#!/bin/bash

### FiraCode
git clone https://github.com/tonsky/FiraCode.git $HOME/bin/fira
sudo mkdir -p /usr/share/fonts/truetype/firaCode
cp -a $HOME/bin/fira/distr/ttf/*.ttf /usr/share/fonts/truetype/firaCode/

# Cleanup downloaded fonts
rm -Rf $HOME/bin/fira

### Powerline patched fonts
git clone https://github.com/powerline/fonts.git $HOME/bin/powerline
sh $HOME/bin/powerline/install.sh

# Regenerate fonts
fc-cache -f -v
