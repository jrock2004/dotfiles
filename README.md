This is a place for me to store my configuration so that when I get a new machine or re-install one, I can set my computer back up as fast as possible.

## Before you Start

Make sure, that before you start that you install the following apps that are required for everything to work.

<details>
  <summary>Mac</summary>

- Xcode Command Line Tools
- Git

Xcode will give your mac all the tools you will need to run the scripts.

</details>

## Running the Install Script

```bash
> git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles
> cd ~/.dotfiles

# If you want to see options, run the following:
> ./install.sh

# To run the default setup
> ./install.sh all
```

## After Script has Ran

So if the script runs through and you receive no errors, open a new terminal window and we will install some things that the installer could not do.

I use [Volta](https://volta.sh) at this time to manage my node versions and node dependencies. Lets start off by install LTS version of Node

```bash
> volta install node@lts
```

Now lets install some global node plugins globally that I use that are not required for my dotfiles.

```bash
> volta install yarn ember-cli
```

---

## Old Dotfiles

These are all the configuration that I use for all my apps.

![img](assets/screenshot.png)

## Configure Some Apps

Lets document how I set up some of the apps I use

### iTerm

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

### VS Code

Extensions and settings can be [found on gist](https://gist.github.com/jrock2004/34c134d3a4a8bfb84336fd5d52472237)

## Inspiration

My inspiration of my dotfiles comes from [Nick Nisi](https://github.com/nicknisi/dotfiles).
Thank you for showing me the way
