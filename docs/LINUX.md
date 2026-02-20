# Linux-Specific Documentation

This guide covers Linux-specific features, configurations, and troubleshooting for the dotfiles across multiple distributions.

## Table of Contents

- [Overview](#overview)
- [Supported Distributions](#supported-distributions)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Package Management](#package-management)
- [Shell Configuration](#shell-configuration)
- [Window Management](#window-management)
- [Fonts](#fonts)
- [Distribution-Specific Notes](#distribution-specific-notes)
- [Troubleshooting](#troubleshooting)
- [Performance Tips](#performance-tips)

## Overview

The dotfiles support multiple Linux distributions with automatic detection and platform-specific package installation:

**Supported Features**:
- **Package Management**: apt, dnf, pacman with automatic detection
- **Shell Theme**: Starship prompt (cross-platform, fast)
- **Fonts**: Nerd Fonts via direct downloads
- **Window Management**: i3/sway (optional, not installed by default)
- **Display Managers**: Works with GNOME, KDE, Xfce, i3, sway

**Supported Architectures**:
- x86_64 (AMD64)
- ARM64 (aarch64)

## Supported Distributions

| Distribution | Package Manager | Status | Tested Versions |
|-------------|----------------|--------|----------------|
| Ubuntu | apt-get | ✅ Fully Supported | 20.04, 22.04, 24.04 |
| Debian | apt-get | ✅ Fully Supported | 11 (Bullseye), 12 (Bookworm) |
| Fedora | dnf | ✅ Fully Supported | 38, 39, 40 |
| RHEL/Rocky/Alma | dnf | ✅ Fully Supported | 8, 9 |
| Arch Linux | pacman | ✅ Fully Supported | Rolling |
| Manjaro | pacman | ✅ Fully Supported | Rolling |

**Planned Support**:
- openSUSE (zypper)
- Gentoo (emerge)
- NixOS (nix)

## Prerequisites

### Ubuntu/Debian

```bash
# Update package list
sudo apt-get update

# Install build tools
sudo apt-get install -y build-essential

# Install required tools
sudo apt-get install -y git curl wget

# Optional: add-apt-repository (for PPAs)
sudo apt-get install -y software-properties-common
```

### Fedora/RHEL

```bash
# Update system
sudo dnf update

# Install development tools
sudo dnf groupinstall -y "Development Tools"

# Install required tools
sudo dnf install -y git curl wget

# Optional: enable EPEL (RHEL/Rocky/Alma)
sudo dnf install -y epel-release
```

### Arch Linux

```bash
# Update system
sudo pacman -Syu

# Install base development tools
sudo pacman -S --needed base-devel

# Install required tools
sudo pacman -S git curl wget
```

**Optional: Install yay (AUR helper)**:
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Installation

### Quick Install

```bash
# One-line install (auto-detects distribution)
bash <(curl -L https://raw.githubusercontent.com/jrock2004/dotfiles/main/scripts/curl-install.sh)
```

### Local Install

```bash
# Clone repository
git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Interactive installation
./install.sh

# Non-interactive (recommended for Linux)
./install.sh --non-interactive
```

### Selective Installation

```bash
# Install minimal setup
./install.sh --only shell,stow

# Install development tools
./install.sh --only shell,neovim,tmux,volta,stow

# Skip components
./install.sh --skip lua,rust,claude
```

## Package Management

### Package Files Structure

```
packages/
├── common.txt                      # Cross-platform CLI tools
├── optional.txt                    # Optional tools
├── linux/
│   ├── core.txt                   # Linux-specific CLI tools
│   ├── gui-apps.txt               # GUI apps (native packages)
│   ├── gui-apps-flatpak.txt       # Flatpak apps
│   └── gui-apps-snap.txt          # Snap apps
├── mappings/
│   ├── common-to-ubuntu.map       # Ubuntu package name mappings
│   ├── common-to-fedora.map       # Fedora package name mappings
│   └── common-to-arch.map         # Arch package name mappings
```

### Adding Packages

**Cross-platform CLI tools**:
```bash
# Add to common.txt
echo "htop" >> packages/common.txt

# Add mappings if package name differs
echo "htop=htop" >> packages/mappings/common-to-ubuntu.map
echo "htop=htop" >> packages/mappings/common-to-fedora.map
echo "htop=htop" >> packages/mappings/common-to-arch.map

# Validate
./scripts/validate-packages.sh

# Install
./scripts/install.sh --only homebrew --force
```

**Linux-specific packages**:
```bash
# Native packages
echo "package-name" >> packages/linux/core.txt

# Flatpak apps
echo "org.gimp.GIMP" >> packages/linux/gui-apps-flatpak.txt

# Snap apps
echo "vlc" >> packages/linux/gui-apps-snap.txt
```

### Package Manager Commands

#### Ubuntu/Debian (apt-get)

```bash
# Update package list
sudo apt-get update

# Install package
sudo apt-get install -y package-name

# Upgrade all packages
sudo apt-get upgrade

# Search for package
apt-cache search package-name

# Remove package
sudo apt-get remove package-name

# Clean up
sudo apt-get autoremove
sudo apt-get autoclean
```

#### Fedora/RHEL (dnf)

```bash
# Update system
sudo dnf update

# Install package
sudo dnf install -y package-name

# Search for package
dnf search package-name

# Remove package
sudo dnf remove package-name

# Clean up
sudo dnf autoremove
sudo dnf clean all
```

#### Arch Linux (pacman)

```bash
# Update system
sudo pacman -Syu

# Install package
sudo pacman -S package-name

# Search for package
pacman -Ss package-name

# Remove package
sudo pacman -R package-name

# Clean cache
sudo pacman -Sc
```

**AUR packages (with yay)**:
```bash
# Install from AUR
yay -S package-name

# Update AUR packages
yay -Syu
```

### Flatpak

**Setup**:
```bash
# Ubuntu/Debian
sudo apt-get install -y flatpak

# Fedora (usually pre-installed)
sudo dnf install -y flatpak

# Arch
sudo pacman -S flatpak

# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

**Usage**:
```bash
# Install app
flatpak install flathub org.gimp.GIMP

# List installed
flatpak list

# Update all
flatpak update

# Remove app
flatpak uninstall org.gimp.GIMP
```

### Snap

**Setup**:
```bash
# Ubuntu (usually pre-installed)
sudo apt-get install -y snapd

# Fedora
sudo dnf install -y snapd
sudo ln -s /var/lib/snapd/snap /snap

# Arch
yay -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
```

**Usage**:
```bash
# Install app
sudo snap install app-name

# List installed
snap list

# Update all
sudo snap refresh

# Remove app
sudo snap remove app-name
```

## Shell Configuration

### Starship Prompt

**Starship** replaces Powerlevel10k on Linux (cross-platform, Rust-based, fast):

**Installation**:
```bash
# Via dotfiles installer
./install.sh --only shell

# Or manually
curl -sS https://starship.rs/install.sh | sh
```

**Configuration**: `~/.config/starship.toml`

**Customize**:
```bash
# Edit config
nvim ~/.config/starship.toml

# Reload shell
exec zsh
```

**Example config**:
```toml
# Get editor completions based on the config schema
"$schema" = 'https://starship.rs/config-schema.json'

# Prompt format
format = """
[┌───────────────────>](bold green)
[│](bold green)$directory$git_branch$git_status
[└─>](bold green) """

# Directory module
[directory]
truncation_length = 3
truncate_to_repo = true
format = "[$path]($style)[$read_only]($read_only_style) "

# Git branch
[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "

# Git status
[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
```

**Presets**:
```bash
# Try different presets
starship preset nerd-font-symbols -o ~/.config/starship.toml
starship preset pure-preset -o ~/.config/starship.toml
starship preset gruvbox-rainbow -o ~/.config/starship.toml
```

### zsh Configuration

**Shell setup** via dotfiles includes:
- zsh as default shell
- zap plugin manager
- Starship prompt
- Custom functions and aliases
- fzf integration
- Syntax highlighting
- Autosuggestions

**Change default shell**:
```bash
# Check current shell
echo $SHELL

# Change to zsh
chsh -s $(which zsh)

# Verify (requires logout/login)
echo $SHELL
```

## Window Management

### i3 Window Manager

**Optional i3 installation** (not included by default):

#### Ubuntu/Debian

```bash
sudo apt-get install -y i3-wm i3status i3lock dmenu

# Add to .xinitrc
echo "exec i3" >> ~/.xinitrc
```

#### Fedora

```bash
sudo dnf install -y i3 i3status i3lock dmenu

# Select i3 from login screen
```

#### Arch

```bash
sudo pacman -S i3-wm i3status i3lock dmenu

# Add to .xinitrc
echo "exec i3" >> ~/.xinitrc
```

**Configuration**: `~/.config/i3/config` (create custom config if needed)

### Sway (Wayland Compositor)

**Modern i3 alternative** for Wayland:

```bash
# Ubuntu/Debian
sudo apt-get install -y sway swaylock swayidle wofi

# Fedora
sudo dnf install -y sway swaylock swayidle wofi

# Arch
sudo pacman -S sway swaylock swayidle wofi
```

**Configuration**: `~/.config/sway/config`

## Fonts

### Nerd Fonts Installation

**Fonts installed to**: `~/.local/share/fonts/`

**Via dotfiles installer**:
```bash
./install.sh --only fonts
```

**Manual installation**:
```bash
# Create fonts directory
mkdir -p ~/.local/share/fonts

# Download Nerd Font (example: Meslo)
cd ~/.local/share/fonts
curl -fLo "Meslo LG S Regular Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/MesloLGSNerdFont-Regular.ttf

# Refresh font cache
fc-cache -fv

# Verify
fc-list | grep -i meslo
```

**Recommended Nerd Fonts**:
- Meslo LG Nerd Font
- Hack Nerd Font
- JetBrains Mono Nerd Font
- Fira Code Nerd Font

### Terminal Configuration

**Alacritty** (`~/.config/alacritty/alacritty.yml`):
```yaml
font:
  normal:
    family: "MesloLGS Nerd Font"
  size: 12.0
```

**Kitty** (`~/.config/kitty/kitty.conf`):
```
font_family MesloLGS Nerd Font
font_size 12.0
```

**WezTerm** (`~/.config/wezterm/wezterm.lua`):
```lua
config.font = wezterm.font("MesloLGS Nerd Font")
config.font_size = 12.0
```

**GNOME Terminal**:
```bash
# Set font via GUI: Preferences → Profile → Text → Custom font
# Or via gsettings:
gsettings set org.gnome.desktop.interface monospace-font-name 'MesloLGS Nerd Font 12'
```

## Distribution-Specific Notes

### Ubuntu/Debian

**PPAs for newer software**:
```bash
# Neovim (latest stable)
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim

# Zsh (latest)
sudo add-apt-repository ppa:zsh-users/zsh
sudo apt-get update
sudo apt-get install zsh
```

**Package name differences**:
- `fd` → `fd-find`
- `bat` → `batcat`

**Create aliases** if needed:
```bash
# Add to ~/.zshrc
alias fd='fd-find'
alias bat='batcat'
```

### Fedora/RHEL

**Enable EPEL** (RHEL/Rocky/Alma):
```bash
sudo dnf install -y epel-release
```

**Copr repositories** (like PPAs):
```bash
# Neovim nightly
sudo dnf copr enable agriffis/neovim-nightly
sudo dnf install neovim
```

**DNF config optimization**:
```bash
# Edit /etc/dnf/dnf.conf
sudo tee -a /etc/dnf/dnf.conf <<EOF
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
EOF
```

### Arch Linux

**AUR packages** (requires yay or another AUR helper):
```bash
# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install AUR packages
yay -S package-name
```

**pacman configuration**:
```bash
# Enable parallel downloads
# Edit /etc/pacman.conf
# Uncomment: ParallelDownloads = 5

# Enable color output
# Uncomment: Color

# Enable verbose package lists
# Uncomment: VerbosePkgLists
```

## Troubleshooting

### Shell Not Changed to zsh

**Issue**: Login shell still bash after installation

**Solution**:
```bash
# Check available shells
cat /etc/shells

# Ensure zsh is listed
# If not:
which zsh | sudo tee -a /etc/shells

# Change shell
chsh -s $(which zsh)

# Logout and login again
```

### Font Not Showing in Terminal

**Issue**: Nerd Font icons not displaying

**Solution**:
```bash
# Verify font installation
fc-list | grep -i "nerd font"

# Refresh font cache
fc-cache -fv

# Set terminal font to Nerd Font
# Edit terminal preferences/config

# Restart terminal
```

### Package Not Found

**Issue**: Package name not found during installation

**Ubuntu/Debian**:
```bash
# Update package list
sudo apt-get update

# Search for package
apt-cache search package-name
```

**Fedora**:
```bash
# Search for package
dnf search package-name

# Check if EPEL needed
sudo dnf install epel-release
```

**Arch**:
```bash
# Search official repos
pacman -Ss package-name

# Search AUR
yay -Ss package-name
```

### Permission Denied Errors

**Issue**: Can't write to certain directories

**Solution**:
```bash
# Ensure ~/.local/bin exists and is writable
mkdir -p ~/.local/bin
chmod 755 ~/.local/bin

# For system-wide installs, use sudo
sudo apt-get install package-name

# For user installs, use appropriate flags
pip install --user package-name
cargo install --root ~/.local package-name
```

### Neovim Version Too Old

**Ubuntu/Debian**:
```bash
# Add Neovim PPA
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
```

**Fedora**:
```bash
# Use Copr
sudo dnf copr enable agriffis/neovim-nightly
sudo dnf install neovim
```

**Arch**:
```bash
# Install from official repos (usually latest)
sudo pacman -S neovim

# Or build from source
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
```

### systemd User Services

**Issue**: User services not starting automatically

**Solution**:
```bash
# Enable lingering (allows user services when not logged in)
sudo loginctl enable-linger $USER

# Start service
systemctl --user start service-name

# Enable service
systemctl --user enable service-name

# Check status
systemctl --user status service-name
```

## Performance Tips

### Optimize Package Manager

**Ubuntu/Debian**:
```bash
# Use apt-fast for parallel downloads
sudo add-apt-repository ppa:apt-fast/stable
sudo apt-get update
sudo apt-get install apt-fast
```

**Fedora**:
```bash
# Edit /etc/dnf/dnf.conf
fastestmirror=True
max_parallel_downloads=10
```

**Arch**:
```bash
# Edit /etc/pacman.conf
# Uncomment: ParallelDownloads = 5
```

### Optimize Shell Startup

```bash
# Profile zsh startup time
time zsh -i -c exit

# Disable unused zap plugins in ~/.zshrc
# Comment out plugins you don't use

# Use Starship (fast, Rust-based)
# Already default on Linux
```

### Reduce Memory Usage

```bash
# Check memory usage
free -h

# Disable unused services
systemctl --user disable unused-service

# Use lighter alternatives
# - i3 instead of GNOME/KDE
# - Alacritty instead of GNOME Terminal
# - fish/zsh instead of bash
```

## Linux-Specific Tips

### Clipboard Integration

**X11**:
```bash
# Install xclip
sudo apt-get install xclip  # Ubuntu
sudo dnf install xclip      # Fedora
sudo pacman -S xclip        # Arch

# Use in scripts
echo "text" | xclip -selection clipboard
```

**Wayland**:
```bash
# Install wl-clipboard
sudo apt-get install wl-clipboard  # Ubuntu
sudo dnf install wl-clipboard      # Fedora
sudo pacman -S wl-clipboard        # Arch

# Use in scripts
echo "text" | wl-copy
```

### Desktop Integration

**Create .desktop files** for custom apps:

```bash
# Location
~/.local/share/applications/custom-app.desktop

# Example content
[Desktop Entry]
Type=Application
Name=Custom App
Exec=/path/to/app
Icon=/path/to/icon.png
Terminal=false
Categories=Development;
```

### Terminal Multiplexer

**tmux** recommended for headless servers:

```bash
# Start tmux
tmux

# Create session
tmux new -s work

# Attach to session
tmux attach -t work

# List sessions
tmux ls
```

---

For more information:
- [Main README](../README.md)
- [General Documentation](../CLAUDE.md)
- [macOS Documentation](MACOS.md)
- [WSL Documentation](WSL.md)
