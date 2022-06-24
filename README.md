This is a place for me to store my configuration so that when I get a new machine or re-install one, I can set my computer back up as fast as possible.

## before you start

Make sure, that before you start that you install the following apps that are required for everything to work.

<details>
  <summary>Mac</summary>

- Xcode Command Line Tools
- Git

Xcode will give your mac all the tools you will need to run the scripts.

</details>

## running the install script

```bash
> git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles
> cd ~/.dotfiles

# If you want to see options, run the following:
> ./install.sh

# To set up your Mac you can run
> ./install.sh mac
```

## after script has ran

So if the script runs through and you receive no errors, open a new terminal window and we will install some things that the installer could not do.

I use [Volta](https://volta.sh) at this time to manage my node versions and node dependencies. Lets start off by install LTS version of Node

```bash
> volta install node@lts
```

Now lets install some global node plugins globally that I use that are not required for my dotfiles.

```bash
> volta install yarn
```

```bash
> npmpackages
```

Now lets install stylua with cargo:

```bash
> cargo install stylua
```

## open up neovim

Open up Neovim and we need to run some commands to get us set up and ready

```bash
:PackerInstall
```

After this is done, close it out and open it again and run the following to install all the language servers. Open up Neovim and `,lI` and you will want to go in list and hit `I` on the following:

◍ graphql
◍ bashls
◍ dockerls
◍ eslint
◍ html
◍ yamlls
◍ cssls
◍ cssmodules_ls
◍ diagnosticls
◍ ember
◍ emmet_ls
◍ tsserver
◍ tailwindcss

## settings for iTerm2

If you are on a mac you will want to use iTerm2 for your terminal. Here are the settings I have configured for it

```yml
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

## vscode

I do not use it as much but I still configure it for when I have to use it. It can be [found on gist](https://gist.github.com/jrock2004/34c134d3a4a8bfb84336fd5d52472237)

## inspiration

My inspiration of my dotfiles comes from [Nick Nisi](https://github.com/nicknisi/dotfiles).
The next person who got me into converting my neovim setup to Lua is [Chris@Machine](https://www.chrisatmachine.com/neovim). Thank you for showing me the way.



-------

# Arch

There are things you will need to do to get your Arch setup up and running. There is a directory called `archfiles` that you need to move to the right places.

```bash
> cd ~/.dotfiles/archfiles
```

Then you can run the following to install all the packages that are required.

```bash
> cp 91-keyboard-mouse-wakeup.conf /etc/udev/rules.d/
```

You will want to clone and install `slock` with the following

```bash
> git clone https://git.suckless.org/slock
> cd slock
> sudo make install
```

Now lets get audio working

```bash
> systemctl --user enable pipewire
> systemctl --user enable pipewire-pulse
> systemctl --user enable pipewire-media-session
```

Now lets get virtual machine working

```bash
> sudo systemctl enable libvirtd.service
```

Then follow here for [configuration](https://wiki.archlinux.org/title/Virt-Manager).
