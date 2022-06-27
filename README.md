# Dotfiles

This holds all my configuration that I use for my linux and mac machines. When ever I get a new computer or reformat one, I clone and run this to get setup fairly quickly. If you find that the script does not work for the OS's listed below or your there is some bug, [please open an issue](https://github.com/jrock2004/dotfiles/issues).

# Current OS's Supported
- Arch
- PopOS
- Mac

# Pre-req

There are a few things that you need to install yourself before you can use the script

## General

- Git

## Mac

Xcode Command Line Tools is required to give you some of the needed core dependencies this script will need to run. You can install this by doing the following:

``` bash
> sudo xcode-select --install
```

# Run the Script

You should now be ready to clone and run the script to get going

``` bash
> git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles
> cd ~/.dotfiles

# If you want to see options, run the following:
> ./install.sh
```

When you run the script is going to ask you questions so it knows what to set up. If it completes with no errors and you see the success message at the end then everything should be good to go. If not, [please open an issue](https://github.com/jrock2004/dotfiles/issues) with what errored out for you.

# SSH Key

I prefer to use SSH to authenticate to Github, so the next thing we should do is create an SSH key.

``` bash
> ssh-keygen -t ed25519 -C "your_email@example.com"
> eval "$(ssh-agent -s)"
> ssh-add ~/.ssh/id_ed25519
> cat ~/.ssh/id_ed25519.pub

# Then select and copy the contents of the id_ed25519.pub file
# displayed in the terminal to your clipboard
```

Now you can add the SSH key to your account so you will have no issues cloning repos using `git:` protocol. We are ready to open a new terminal which should use our new configurations. It will download some ZSH plugins that I like to use.

# NodeJS

Currently my favorite node manager is [Volta](https://volta.sh/). We want to run the following to setup node and some global node dependencies that I use on a day to day.

``` bash
# Install Node LTS version
> volta install node@lts yarn

# Globalling install some Node dependencies
> npmpackages
```

**Note:** If you are curious which Node dependencies I globally install, [you can view here](https://github.com/jrock2004/dotfiles/blob/main/files/.zshrc#L246).

# Setup Neovim

Open up neovim with the command `nvim` and an error will come at bottom of screen. Hit `enter` and the Packer installer will come up. You may see some errors and that is ok. Once all the plugins have installed, closed Neovim and re-open. Its going to download some other dependencies. This will take a few minutes as there are alot of them. Once that completes, close Neovim and re-open again. We now want to install some LSP Servers. to do this hit the following keys to open the LSP installer, `,lI`(comma, l, I). Navigate down to each of the following in the list and hit `i` to install it. Should take a few seconds to install. You need to wait for install finish before clicking `i` on another one.

```
◍ bashls
◍ cssls
◍ cssmodules_ls
◍ diagnosticls
◍ dockerls
◍ ember
◍ emmet_ls
◍ eslint
◍ html
◍ jsonls
◍ pyright
◍ sumneko_lua
◍ tailwindcss
◍ tsserver
◍ vimls
◍ yamlls
```

# Setup VSCode

I do use [Visual Studio Code](https://code.visualstudio.com) from time to time. I think mostly for git merge conflicts. I have a [gist setup of the dependencies and settings that I use](https://gist.github.com/jrock2004/34c134d3a4a8bfb84336fd5d52472237).

# Mac Specific Setup

There are some things that you will want to set up that are specific for apps that are only on Mac. 

## iTerm2

On Mac my go to terminal is [iTerm2](https://iterm2.com/)

``` yml
General:
  Closing:
    Confirm Quit: Un-checked
  Selection:
    Access Clipboard: Check
Appearance:
  General:
    Theme: Minimal
Profiles:
  Colors:
    Color Presets: Ayu Dark
  Text:
    Enable subpixel: Check
    Font: Dank Mono
    Font Weight: Regular
    Font Size: 22
    Letter Space: 100
    Line Space: 130
    Use ligatures
    Use different font: Check
    Non-ASCII Font: FiraCode Nerd Font Mono
    Non-ASCII Weight: Regular
    Non-ASCII Size: 22
    Non-ASCII Ligatures: Check
```

# Arch

I have not fully automated my Arch set up so there are some things that you will want to do at this point to get all things working.

## Virtual Machine

From time to time I need to run a VM to play around with things or test. On Arch I use an app called [Virt-Manager](https://wiki.archlinux.org/title/Virt-Manager). My installer installs the application but we need to config it

### /etc/libvirt/libvirtd.conf

Open this file and you will want to uncomment and change the following values:

- unix_sock_group = 'libvirt'
- unix_sock_rw_perms = '0770'

### /etc/libvirt/qemu.conf

Change the following values of username to the username that you choose for your linux account.

- user = "username"
- group = "username"

### Add Youself to the Group

You need to add yourself to this group or else you will not be able to run this without root. 

``` bash
> sudo usermod -a -G libvirt username
```

### Enable the Service on Startup

```bash
> sudo systemctl enable libvirtd.service
```

# Inspiration

When I started using Vim, my configs forked off of [Nick Nisi](https://github.com/nicknisi/dotfiles). I found Nick's config off of an awesome [Youtube video explaining Vim and Tmux](https://www.youtube.com/watch?v=5r6yzFEXajQ). A few years later I came acrros Christian Chiarulli videos at got interested in switching my Neovim config from vimscript to lua script. I started to play around with things. Chris then came up with a great [Youtube series](https://www.youtube.com/watch?v=Vghglz2oR0c) on setting up a basic Neovim IDE. [You can view the code for that on his github](https://github.com/LunarVim/nvim-basic-ide).
