My Dotfiles
=

This repo is used to store my dotfiles for the applications that I use on my machine

## Branches
- master - Bash on Windows
- linux - Used when you are running Linux [Debian based, tested on elementary os]
- mac - Used on Apple [Tested on El Capitan]
- bashonwindows - Bash on Windows

## Pre-req
You need to just install git so you can clone the repo. If you are on mac you will need to open the terminal and run
xcode-select --install and this will get you git and the other things needed

## How to use
Below lists the ways to grab this and restore the dotfiles and install the applications. Before running the install
command you will want to edit the install.sh and update the variables if needed.

### Bash on Windows
```
$ sudo apt-get install git
$ git clone https://github.com/jrock2004/dotfiles.git .dotfiles
$ cd ~/.dotfiles
$ git checkout bashonwindows
$ ./install.sh
```

### Linux
```
$ sudo apt-get install git
$ git clone https://github.com/jrock2004/dotfiles.git .dotfiles
$ cd ~/.dotfiles
$ git checkout linux
$ ./install.sh
```

### Mac
```
$ xcode-select --install
$ git clone https://github.com/jrock2004/dotfiles.git .dotfiles
$ cd ~/.dotfiles
$ git checkout
$ ./install.sh
```

## Thanks
This repo was originally forked from another user. I have taken it and made changes to match my needs. I would like to
thank [Nick Nisi](https://github.com/nicknisi/dotfiles).
