#!/bin/bash

DOTFILES=$HOME/.dotfiles
OS=`uname`

echo "creating symlinks"
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$HOME/.$( basename $file ".symlink" )"

    if [ -f $target ]; then
    	echo "$target already exists"
    else
    	echo "creating symlink for $file to $target"
	ln -s $file $target
    fi
done

echo -e "\n\ninstalling to ~/.config"
echo "=============================="
if [ ! -d $HOME/.config ]; then
    echo "Creating ~/.config"
    mkdir -p $HOME/.config
fi
# configs=$( find -path "$DOTFILES/config.symlink" -maxdepth 1 )
for config in $DOTFILES/config/*; do
    target=$HOME/.config/$( basename $config )
    if [ -e $target ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $config to $target"
        ln -s $config $target
    fi
done
