# macOS-Specific Documentation

This guide covers macOS-specific features, configurations, and troubleshooting for the dotfiles.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [macOS-Specific Features](#macos-specific-features)
- [Installation](#installation)
- [Window Management](#window-management)
- [Homebrew](#homebrew)
- [Fonts](#fonts)
- [Powerlevel10k Theme](#powerlevel10k-theme)
- [macOS Defaults](#macos-defaults)
- [Troubleshooting](#troubleshooting)
- [Performance Tips](#performance-tips)

## Overview

The dotfiles include macOS-specific configurations for:
- **Window Management**: yabai, skhd, sketchybar
- **Package Management**: Homebrew (Intel & ARM)
- **Shell Theme**: Powerlevel10k
- **Fonts**: Nerd Fonts via Homebrew casks
- **System Defaults**: macOS preferences automation

**Supported Versions**:
- macOS 12 (Monterey) and later
- Intel (x86_64) and Apple Silicon (ARM64/M1/M2/M3)

## Prerequisites

### Xcode Command Line Tools

Required for Homebrew and development tools:

```bash
# Check if installed
xcode-select -p

# Install if not present
xcode-select --install

# Verify installation
xcode-select -p
# Output: /Library/Developer/CommandLineTools
```

### Rosetta 2 (Apple Silicon Only)

Required for some x86_64 packages:

```bash
# Check if installed
/usr/bin/pgrep -q oahd && echo "Rosetta is installed" || echo "Rosetta is not installed"

# Install if needed (automatic during dotfiles install)
softwareupdate --install-rosetta --agree-to-license
```

### Full Disk Access (Optional)

Some tools (yabai, skhd) require Full Disk Access:

1. System Preferences → Security & Privacy → Privacy
2. Full Disk Access → Add applications (yabai, skhd)

## macOS-Specific Features

### Window Management (yabai + skhd + sketchybar)

**yabai**: Tiling window manager
- Auto-tiling windows
- Workspace management
- Focus follows mouse
- Custom layouts

**skhd**: Hotkey daemon
- Global keyboard shortcuts
- Window movement shortcuts
- Workspace switching
- Custom key bindings

**sketchybar**: Status bar replacement
- Custom menubar
- System information
- Workspace indicators
- Custom widgets

**Configuration files**:
```
files/.config/yabai/yabairc
files/.config/skhd/skhdrc
files/.config/sketchybar/
```

**Enable window management**:
```bash
# Install yabai, skhd, sketchybar
./install.sh --only homebrew

# Start services
yabai --start-service
skhd --start-service
brew services start sketchybar

# Verify
yabai --check-sa
```

### Homebrew Package Manager

**Installation paths**:
- **Intel**: `/usr/local/bin/brew`
- **Apple Silicon**: `/opt/homebrew/bin/brew`

**Environment setup**:
```bash
# Intel
eval "$(/usr/local/bin/brew shellenv)"

# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"
```

**Package files**:
```
packages/macos/core.txt         # CLI tools
packages/macos/gui-apps.txt     # GUI applications (casks)
packages/macos/fonts.txt        # Fonts
packages/macos/macos-only.txt   # yabai, skhd, sketchybar
packages/macos/taps.txt         # Homebrew taps
```

### Powerlevel10k Theme

**Features**:
- Fast prompt
- Git status integration
- Command execution time
- Instant prompt
- Customizable segments

**Configuration**:
```bash
# Initial setup
p10k configure

# Config file
~/.p10k.zsh

# Reload
exec zsh
```

**Segments**:
- Current directory
- Git branch and status
- Command execution time
- Background jobs
- Node.js version (via Volta)
- Python virtualenv
- Time

### Fonts

**Nerd Fonts** installed via Homebrew casks:
```
packages/macos/fonts.txt:
  font-meslo-lg-nerd-font
  font-fira-code-nerd-font
  font-hack-nerd-font
  font-jetbrains-mono-nerd-font
```

**Installation**:
```bash
# Via dotfiles installer
./install.sh --only fonts

# Or manually
brew install --cask font-meslo-lg-nerd-font
```

**Verify installation**:
```bash
# List installed fonts
brew list --cask | grep font-

# Font location
ls ~/Library/Fonts
```

**Terminal configuration**:
- **Ghostty**: Edit `~/.config/ghostty/config`
- **Alacritty**: Edit `~/.config/alacritty/alacritty.yml`
- **Kitty**: Edit `~/.config/kitty/kitty.conf`
- **WezTerm**: Edit `~/.config/wezterm/wezterm.lua`

### macOS System Defaults

**Automated defaults** via `macos-defaults` component:

```bash
# Apply macOS defaults
./install.sh --only macos-defaults

# Preview defaults (dry-run)
./install.sh --only macos-defaults --dry-run
```

**Configured settings**:
- Show hidden files in Finder
- Expand save panel by default
- Disable Resume system-wide
- Faster keyboard repeat rate
- Enable full keyboard access
- Show all file extensions
- Disable .DS_Store on network volumes
- Enable snap-to-grid for desktop icons

**Custom defaults**:

Edit `scripts/components/macos-defaults.sh` (if exists) or create custom script:

```bash
# Example custom defaults
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.dock autohide -bool true
killall Finder
killall Dock
```

## Installation

### Quick Install

```bash
# One-line install
bash <(curl -L https://raw.githubusercontent.com/jrock2004/dotfiles/main/scripts/curl-install.sh)
```

### Local Install

```bash
# Clone repository
git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Interactive installation
./install.sh

# Non-interactive (CI/automation)
./install.sh --non-interactive
```

### Selective Installation

```bash
# Install only window management
./install.sh --only homebrew,macos-defaults

# Skip window management
./install.sh --skip macos-defaults

# Install minimal setup
./install.sh --only shell,stow
```

## Window Management

### yabai Setup

**Installation**:
```bash
# Via dotfiles
./install.sh --only homebrew

# Start service
yabai --start-service
```

**Configuration**: `~/.config/yabai/yabairc`

**Common commands**:
```bash
# Start
yabai --start-service

# Stop
yabai --stop-service

# Restart
yabai --restart-service

# Check status
yabai --check-sa

# Reload config
yabai --reload-config
```

**Default layout**:
- BSP (Binary Space Partitioning)
- Auto-balance windows
- 10px gaps between windows
- Focus follows mouse (delayed)

**Customization**:
Edit `~/.config/yabai/yabairc`:
```bash
# Change layout
yabai -m config layout stack  # Or: bsp, float

# Change gaps
yabai -m config window_gap 20

# Disable focus follows mouse
yabai -m config focus_follows_mouse off
```

### skhd Setup

**Configuration**: `~/.config/skhd/skhdrc`

**Default keybindings**:
```bash
# Window focus
alt - h : yabai -m window --focus west
alt - j : yabai -m window --focus south
alt - k : yabai -m window --focus north
alt - l : yabai -m window --focus east

# Window movement
shift + alt - h : yabai -m window --swap west
shift + alt - j : yabai -m window --swap south
shift + alt - k : yabai -m window --swap north
shift + alt - l : yabai -m window --swap east

# Workspace switching
alt - 1 : yabai -m space --focus 1
alt - 2 : yabai -m space --focus 2
# ... etc

# Float / unfloat window
shift + alt - space : yabai -m window --toggle float
```

**Customization**:
Edit `~/.config/skhd/skhdrc` and reload:
```bash
# Reload skhd config
skhd --reload
```

### sketchybar Setup

**Configuration**: `~/.config/sketchybar/`

**Features**:
- Custom menubar replacement
- Workspace indicators
- System stats (CPU, RAM, battery)
- Date and time
- Custom scripts and widgets

**Start/stop**:
```bash
# Start
brew services start sketchybar

# Stop
brew services stop sketchybar

# Restart
brew services restart sketchybar

# Reload config
sketchybar --reload
```

## Homebrew

### Managing Packages

**Add new packages**:
```bash
# CLI tools
echo "package-name" >> packages/macos/core.txt

# GUI apps (casks)
echo "app-name" >> packages/macos/gui-apps.txt

# Reinstall
./install.sh --only homebrew --force
```

**Update packages**:
```bash
# Update Homebrew
brew update

# Upgrade all packages
brew upgrade

# Cleanup old versions
brew cleanup
```

**Remove packages**:
```bash
# Uninstall package
brew uninstall package-name

# Remove from package file
# Edit packages/macos/core.txt and remove line
```

### Homebrew Taps

**Add custom taps**:
```bash
# Add to taps file
echo "homebrew/cask-fonts" >> packages/macos/taps.txt

# Install tap
brew tap homebrew/cask-fonts
```

### Intel vs ARM Considerations

**Architecture detection**:
```bash
# Check architecture
uname -m
# x86_64 = Intel
# arm64 = Apple Silicon

# Homebrew prefix
echo $BREW_PREFIX
# /usr/local = Intel
# /opt/homebrew = Apple Silicon
```

**Rosetta packages**:

Some packages require Rosetta on ARM:
```bash
# Install with Rosetta
arch -x86_64 brew install package-name
```

## Fonts

### Installing Fonts

**Via dotfiles**:
```bash
./install.sh --only fonts
```

**Manually**:
```bash
# Install font cask
brew install --cask font-meslo-lg-nerd-font

# Verify
ls ~/Library/Fonts | grep Meslo
```

### Configuring Terminal Font

**Ghostty** (`~/.config/ghostty/config`):
```
font-family = "MesloLGS Nerd Font"
font-size = 14
```

**Alacritty** (`~/.config/alacritty/alacritty.yml`):
```yaml
font:
  normal:
    family: "MesloLGS Nerd Font"
  size: 14.0
```

**Kitty** (`~/.config/kitty/kitty.conf`):
```
font_family MesloLGS Nerd Font
font_size 14.0
```

**WezTerm** (`~/.config/wezterm/wezterm.lua`):
```lua
config.font = wezterm.font("MesloLGS Nerd Font")
config.font_size = 14.0
```

## Powerlevel10k Theme

### Configuration

**Initial setup**:
```bash
# Run configuration wizard
p10k configure

# Follow prompts to customize
```

**Config file**: `~/.p10k.zsh`

**Reconfigure**:
```bash
p10k configure
```

### Customization

**Enable/disable segments**:

Edit `~/.p10k.zsh`:
```bash
# Find POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon                 # OS icon
    dir                     # Current directory
    vcs                     # Git status
    newline                 # Line break
    prompt_char             # Prompt character
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # Exit code
    command_execution_time  # Command duration
    background_jobs         # Background jobs
    direnv                  # Direnv
    asdf                    # ASDF
    virtualenv              # Python virtualenv
    nodeenv                 # Node.js version
    time                    # Current time
)
```

**Reload**:
```bash
exec zsh
```

## macOS Defaults

### Applying System Preferences

**Via dotfiles**:
```bash
./install.sh --only macos-defaults
```

**Preview changes**:
```bash
./install.sh --only macos-defaults --dry-run
```

### Custom Defaults

**Add custom defaults**:

Create `~/custom-macos-defaults.sh`:
```bash
#!/bin/bash

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Restart affected apps
killall Finder
killall Dock
```

**Run custom defaults**:
```bash
chmod +x ~/custom-macos-defaults.sh
~/custom-macos-defaults.sh
```

## Troubleshooting

### Homebrew Issues

**Homebrew not in PATH**:
```bash
# Intel
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile

# Apple Silicon
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# Reload
source ~/.zprofile
```

**Brew doctor warnings**:
```bash
# Run doctor
brew doctor

# Common fixes
brew cleanup
brew update-reset
```

**Permission issues**:
```bash
# Fix permissions
sudo chown -R $(whoami) /usr/local/*  # Intel
sudo chown -R $(whoami) /opt/homebrew/*  # Apple Silicon
```

### yabai Issues

**yabai not working**:
```bash
# Check if running
yabai --check-sa

# Check logs
tail -f /tmp/yabai_*.err.log

# Restart service
yabai --stop-service
yabai --start-service
```

**Scripting addition not loaded**:
```bash
# Disable SIP (System Integrity Protection)
# Reboot into Recovery Mode (Cmd+R)
# Terminal → csrutil disable
# Reboot

# Install scripting addition
sudo yabai --install-sa
yabai --load-sa
```

**Windows not tiling**:
```bash
# Check config
yabai -m config layout bsp

# Reload config
yabai --restart-service
```

### skhd Issues

**Shortcuts not working**:
```bash
# Check if running
ps aux | grep skhd

# Check logs
tail -f /tmp/skhd_*.err.log

# Reload config
skhd --reload
```

**Accessibility permissions**:
1. System Preferences → Security & Privacy → Privacy
2. Accessibility → Add `skhd`

### Powerlevel10k Issues

**Icons not showing**:
- Install Nerd Font: `brew install --cask font-meslo-lg-nerd-font`
- Set terminal font to "MesloLGS Nerd Font"
- Restart terminal

**Prompt not appearing**:
```bash
# Check if p10k loaded
echo $POWERLEVEL9K_MODE

# Reload
exec zsh

# Reconfigure
p10k configure
```

**Slow prompt**:
```bash
# Disable instant prompt
# Edit ~/.p10k.zsh
# Comment out: typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
```

### Font Issues

**Font not available in terminal**:
```bash
# Verify installation
ls ~/Library/Fonts | grep -i meslo

# Reinstall
brew reinstall --cask font-meslo-lg-nerd-font

# Restart terminal
```

**Font looks wrong**:
- Ensure terminal is using the Nerd Font variant
- Try different Nerd Font: Hack, JetBrains Mono, Fira Code
- Check font size (recommended: 12-14pt)

### Rosetta Issues (Apple Silicon)

**Rosetta not installed**:
```bash
# Install Rosetta
softwareupdate --install-rosetta --agree-to-license

# Verify
/usr/bin/pgrep -q oahd && echo "Rosetta installed"
```

**x86_64 package issues**:
```bash
# Run with Rosetta
arch -x86_64 brew install package-name

# Check architecture
file $(which package-name)
```

## Performance Tips

### Optimize Homebrew

```bash
# Disable analytics
brew analytics off

# Cleanup old versions regularly
brew cleanup

# Use shallow clones
export HOMEBREW_NO_GITHUB_API=1
```

### Optimize Shell Startup

```bash
# Profile zsh startup
time zsh -i -c exit

# Disable unused plugins in .zshrc
# Comment out plugins you don't use

# Use instant prompt (Powerlevel10k)
# Already enabled by default
```

### Optimize yabai

```bash
# Reduce yabai polling
# Edit ~/.config/yabai/yabairc
# Comment out unnecessary signals
```

### Reduce Memory Usage

```bash
# Disable unused services
brew services stop unused-service

# Quit unused apps
osascript -e 'quit app "AppName"'

# Check memory usage
top -o MEM
```

## macOS-Specific Tips

### Mission Control Integration

**yabai spaces** integrate with Mission Control:
- Create spaces in Mission Control
- yabai uses existing spaces
- Use `alt + 1-9` to switch spaces (via skhd)

### Keyboard Shortcuts

**System-wide** (via skhd):
- Focus window: `alt + h/j/k/l`
- Move window: `shift + alt + h/j/k/l`
- Switch space: `alt + 1-9`
- Float window: `shift + alt + space`
- Fullscreen: `alt + f`

### Spotlight Alternative

Use **Alfred** or **Raycast** with dotfiles:
```bash
# Install Alfred
brew install --cask alfred

# Or Raycast
brew install --cask raycast
```

### Terminal Emulator Recommendations

**Best for macOS**:
1. **Ghostty** - Fast, native, GPU-accelerated
2. **Alacritty** - Cross-platform, GPU-accelerated
3. **Kitty** - Feature-rich, GPU-accelerated
4. **WezTerm** - Lua-configurable, feature-rich

All configured in `files/.config/`

---

For more information:
- [Main README](../README.md)
- [General Documentation](../CLAUDE.md)
- [Linux Documentation](LINUX.md)
- [WSL Documentation](WSL.md)
