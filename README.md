# Dotfiles

These are all the configuration that I use for all my apps.

![img](assets/screenshot.png)

## Installation
You will want to make sure you install the following applications

- Xcode Command Line Tools
- Git
- Curl

### Cloning the project
```bash
git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles

cd ~/.dotfiles

# To see what options to pass into install run the following:
./install.sh

# Then run what you want
./install.sh all
```

## Configure Some Apps
Lets document how I set up some of the apps I use

### iTerm
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

### VS Code
Extensions and settings can be [found on gist](https://gist.github.com/jrock2004/34c134d3a4a8bfb84336fd5d52472237)

## Inspiration

My inspiration of my dotfiles comes from [Nick Nisi](https://github.com/nicknisi/dotfiles).
Thank you for showing me the way
