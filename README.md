<p align="center">
  <img
    src="docs/mimoji-laptop.png"
    alt="John Costanzo Mimoji of him holding a laptop"
    width="220"
  />
</p>

<p align="center">
  <b>:sparkles: John's Dotfiles :sparkles:</b>
</p>

<p align="center">
  <i>Cross-platform dotfiles for macOS, Linux, and WSL</i>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-features">Features</a> •
  <a href="#-supported-platforms">Platforms</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-troubleshooting">Troubleshooting</a>
</p>

<br />

# Thanks for dropping by!

This repository contains my personal dotfiles, which are configuration files and scripts that customize various aspects of my system. By keeping my dotfiles under version control, I can easily synchronize them across multiple machines and ensure consistency in my development environment.

These dotfiles use a **modular, component-based architecture** with **cross-platform support** for macOS, Linux distributions (Ubuntu, Fedora, Arch), and WSL. The installation system is **idempotent** (safe to run multiple times) and includes automatic backups, rollback on failure, and comprehensive error handling.

## ✨ Features

- **Cross-Platform Support**: Works on macOS (Intel & ARM), Ubuntu, Fedora, Arch Linux, and WSL
- **Modular Architecture**: Component-based installation system
- **Package Management**: Cross-platform package system with OS-specific mappings
- **Idempotent**: Safe to run multiple times without breaking your system
- **Automatic Backups**: Creates backups before overwriting configs
- **Rollback on Failure**: Automatically restores backups if installation fails
- **Interactive UI**: Beautiful prompts with gum/fzf fallbacks
- **Dry-Run Mode**: Preview changes before applying them
- **Selective Installation**: Install only the components you need
- **CI/CD Tested**: Automated testing on macOS and multiple Linux distros
- **Comprehensive Documentation**: Detailed guides for all platforms

## 🖥️ Supported Platforms

| Platform | Status | Package Manager | Notes |
|----------|--------|----------------|-------|
| macOS (Intel) | ✅ Fully Supported | Homebrew | Main development platform |
| macOS (ARM) | ✅ Fully Supported | Homebrew | M1/M2/M3 with Rosetta |
| Ubuntu/Debian | ✅ Fully Supported | apt-get | Tested on 20.04+ |
| Fedora/RHEL | ✅ Fully Supported | dnf | Tested on Fedora 38+ |
| Arch Linux | ✅ Fully Supported | pacman | AUR via yay (optional) |
| WSL1/WSL2 | ✅ Fully Supported | distro-based | Ubuntu, Fedora, or Arch |

## 📦 What's Included

### Core Tools
- **Shell**: zsh with Powerlevel10k (macOS) or Starship (Linux/WSL)
- **Editors**: Neovim (LazyVim), VS Code, Cursor
- **Terminal Emulators**: Ghostty, Alacritty, Kitty, WezTerm
- **Terminal Multiplexers**: tmux, zellij
- **Version Managers**: Volta (Node.js), rustup (Rust)
- **CLI Tools**: fzf, ripgrep, fd, eza, bat, jq, lazygit, lazydocker

### macOS-Specific
- **Window Management**: yabai + skhd + sketchybar
- **Package Manager**: Homebrew
- **Theme**: Powerlevel10k

### Linux-Specific
- **Window Management**: i3/sway (optional)
- **Package Managers**: apt/dnf/pacman, Flatpak/Snap (optional)
- **Prompt**: Starship

### Development
- **Languages**: Go, Python, Lua, Rust
- **Tools**: prettier, stylua, shellcheck
- **Git**: lazygit, gh (GitHub CLI)

## 🚀 Quick Start

### One-Line Install (All Platforms)

```bash
# Automatic OS detection and installation
bash <(curl -L https://raw.githubusercontent.com/jrock2004/dotfiles/main/scripts/curl-install.sh)
```

### Local Install

```bash
# Clone the repository
git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run installer (interactive mode)
./install.sh

# Or run in non-interactive mode (CI/automation)
./install.sh --non-interactive
```

## 📋 Prerequisites

### macOS
- **Xcode Command Line Tools** (installed automatically)
- **Rosetta 2** (ARM Macs, installed automatically if needed)

```bash
# Manual installation (if needed)
xcode-select --install
```

### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y git curl build-essential
```

### Fedora/RHEL
```bash
sudo dnf update
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y git curl
```

### Arch Linux
```bash
sudo pacman -Syu
sudo pacman -S --needed base-devel git curl
```

### WSL (Windows Subsystem for Linux)
- **WSL2** recommended for better performance
- **Base distro** installed (Ubuntu, Fedora, or Arch)
- Follow prerequisite steps for your chosen distro above

## 📦 Installation

### Interactive Installation (Recommended)

```bash
./install.sh
```

This will:
1. Detect your OS and architecture
2. Install package manager if needed
3. Show component selection menu
4. Install selected components
5. Configure OS-specific features
6. Symlink dotfiles to your home directory
7. Create backups of existing configs

### Non-Interactive Installation

```bash
# Use defaults, skip all prompts
./install.sh --non-interactive
```

### Selective Installation

```bash
# Install only specific components
./install.sh --only shell,neovim,tmux

# Skip specific components
./install.sh --skip lua,rust

# List all available components
./install.sh --list-components
```

### Dry-Run Mode

```bash
# Preview what would be installed without executing
./install.sh --dry-run
```

## 🎛️ CLI Options

```bash
# Display help
./install.sh --help

# Show version
./install.sh --version

# List all available components
./install.sh --list-components

# Preview actions without executing
./install.sh --dry-run

# Non-interactive mode (use defaults)
./install.sh --non-interactive

# Force reinstall even if already installed
./install.sh --force

# Skip specific components
./install.sh --skip <component1>,<component2>

# Install only specific components
./install.sh --only <component1>,<component2>
```

## 🔧 Available Components

- `directories` - Create standard directories (~/.local/bin, ~/projects, etc.)
- `homebrew` - Install Homebrew and packages (macOS)
- `vscode` - Install VS Code extensions
- `fonts` - Install Nerd Fonts
- `claude` - Install Claude Code CLI
- `fzf` - Install FZF (fuzzy finder)
- `lua` - Install Lua language server
- `neovim` - Install Neovim dependencies (pynvim)
- `rust` - Install Rust toolchain (rustup)
- `shell` - Configure zsh, zap plugin manager
- `tmux` - Install Tmux Plugin Manager (tpm)
- `volta` - Install Volta and Node.js
- `stow` - Symlink dotfiles with GNU Stow
- `macos-defaults` - Configure macOS defaults (macOS only)

## 🔄 Usage

### Managing Dotfiles

```bash
# Apply/update symlinks (after editing files in files/)
sync

# Remove symlinks
unsync
```

**Important**: All configuration files live in `files/` and are symlinked to `$HOME`. Always edit files in `files/.config/` or `files/`, never the symlinked versions in `$HOME`.

### Updating Dotfiles

```bash
# Pull latest changes and re-apply
./update.sh

# Update without updating packages
./update.sh --no-packages

# Preview update without executing
./update.sh --dry-run
```

### Uninstalling

```bash
# Remove dotfile symlinks only
./uninstall.sh

# Remove symlinks and installed packages
./uninstall.sh --remove-packages

# Preview what would be removed
./uninstall.sh --dry-run
```

### Adding New Packages

**Cross-platform tools**:
```bash
# Add to packages/common.txt
echo "newtool" >> packages/common.txt

# Add platform-specific name mappings if needed
echo "newtool=newtool-bin" >> packages/mappings/common-to-ubuntu.map

# Validate
./scripts/validate-packages.sh

# Install
./scripts/install.sh --only homebrew --force
```

**Platform-specific tools**:
```bash
# macOS
echo "package-name" >> packages/macos/core.txt

# Linux
echo "package-name" >> packages/linux/core.txt

# Reinstall packages
./scripts/install.sh --only homebrew --force
```

### Testing Changes

```bash
# Run ShellCheck on all scripts
./scripts/test-shellcheck.sh

# Run integration tests
./scripts/test-integration.sh

# Test in Docker (Ubuntu)
./test/test-docker.sh ubuntu --build
```

## 🛠️ Configuration

### Configuration File

Create `~/.dotfiles.env` to set default options:

```bash
# Skip specific components
SKIP_COMPONENTS="rust,lua"

# Install only specific components
ONLY_COMPONENTS="shell,neovim"

# Custom backup location
BACKUP_DIR="$HOME/.config/dotfiles-backups"

# Non-interactive mode
NON_INTERACTIVE=true

# Dry-run mode
DRY_RUN=true

# Force reinstall
FORCE_INSTALL=true
```

See `.dotfiles.env.example` for all available options.

### Platform-Specific Configuration

The dotfiles automatically detect your platform and apply the appropriate configuration:

- **macOS**: Uses Homebrew, Powerlevel10k theme, yabai/skhd window management
- **Linux**: Uses apt/dnf/pacman, Starship prompt, optional i3/sway
- **WSL**: Uses distro package manager, Starship prompt, Windows interop

## 🐛 Troubleshooting

### Common Issues

**"Command not found" after installation**:
```bash
# Reload shell configuration
exec zsh
```

**Stow conflicts**:
```bash
# Backup and remove conflicting files
mv ~/.zshrc ~/.zshrc.backup
mv ~/.tmux.conf ~/.tmux.conf.backup

# Re-run stow
./install.sh --only stow --force
```

**Homebrew not in PATH (macOS)**:
```bash
# Intel Macs
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile

# ARM Macs (M1/M2/M3)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# Reload
source ~/.zprofile
```

**Permission denied errors (Linux)**:
```bash
# Ensure scripts are executable
chmod +x install.sh update.sh uninstall.sh
chmod +x scripts/*.sh
```

**Neovim version too old (Linux)**:
```bash
# Ubuntu: Add Neovim PPA
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Fedora: Use copr
sudo dnf copr enable agriffis/neovim-nightly
sudo dnf install neovim

# Arch: Use pacman
sudo pacman -S neovim
```

**WSL systemd not working**:
```bash
# Enable systemd in /etc/wsl.conf
echo "[boot]" | sudo tee /etc/wsl.conf
echo "systemd=true" | sudo tee -a /etc/wsl.conf

# Restart WSL
wsl.exe --shutdown
# Then reopen WSL
```

### Getting Help

```bash
# Show help
./install.sh --help

# Check version
./install.sh --version

# Preview what would be installed
./install.sh --dry-run

# Check logs
tail -f ~/.dotfiles-install.log
```

For more detailed troubleshooting, see `CLAUDE.md` or the platform-specific documentation in `docs/`.

## 📚 Documentation

- **CLAUDE.md** - Comprehensive guide for Claude Code (AI assistant)
- **CONTRIBUTING.md** - Contribution guidelines (to be created)
- **MIGRATION.md** - Migration guide from old system (to be created)
- **docs/MACOS.md** - macOS-specific documentation (to be created)
- **docs/LINUX.md** - Linux-specific documentation (to be created)
- **docs/WSL.md** - WSL-specific documentation (to be created)

## 🏗️ Architecture

This repository uses a **modular, component-based architecture**:

```
dotfiles/
├── files/              # Dotfiles to be symlinked to $HOME
├── packages/           # Cross-platform package management
│   ├── common.txt      # Cross-platform tools
│   ├── optional.txt    # Optional tools
│   ├── macos/          # macOS-specific packages
│   ├── linux/          # Linux-specific packages
│   ├── wsl/            # WSL-specific packages
│   └── mappings/       # Package name mappings
├── scripts/            # Installation scripts
│   ├── lib/            # Shared libraries
│   ├── os/             # OS-specific orchestration
│   ├── components/     # Component setup functions
│   ├── install.sh      # Main installer
│   ├── update.sh       # Update script
│   └── uninstall.sh    # Uninstall script
├── test/               # Docker test environments
└── .github/workflows/  # CI/CD pipelines
```

### Key Features

- **Package Abstraction Layer**: Single interface for Homebrew, apt, dnf, pacman
- **OS Detection**: Automatically detects macOS, Linux distro, WSL
- **Component Dependencies**: Proper ordering and dependency management
- **Error Handling**: Comprehensive error handling with rollback
- **Idempotent**: All operations can be run multiple times safely
- **Testing**: CI/CD with GitHub Actions, Docker tests, ShellCheck

## 🧪 Testing

All shell scripts are tested with:
- **ShellCheck**: Static analysis for shell scripts
- **Integration Tests**: Verify installation works correctly
- **Docker Tests**: Test on Ubuntu, Fedora, and Arch
- **CI/CD**: Automated testing on macOS and Linux via GitHub Actions

```bash
# Run all tests
./scripts/test-shellcheck.sh
./scripts/test-integration.sh
./test/test-docker.sh ubuntu fedora arch
```

## 🤝 Contributing

Contributions are welcome! Whether it's bug fixes, new features, documentation improvements, or platform support, your help is appreciated.

See `CONTRIBUTING.md` (to be created) for detailed guidelines.

## 🔄 Migration from Old System

If you're upgrading from the old monolithic install.sh:

1. **Backup your current setup**:
   ```bash
   cp -r ~/.dotfiles ~/.dotfiles.backup.old
   ```

2. **Pull latest changes**:
   ```bash
   cd ~/.dotfiles
   git pull origin main
   ```

3. **Run new installer**:
   ```bash
   ./install.sh --dry-run  # Preview first
   ./install.sh            # Then install
   ```

4. **Migrate Brewfile** (macOS only):
   ```bash
   ./scripts/migrate-brewfile.sh
   ```

See `MIGRATION.md` (to be created) for detailed migration guide.

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgements

I would like to acknowledge the open-source community and the countless developers who have shared their dotfiles, tips, and tricks. Your contributions have been invaluable in shaping and improving my own setup.

Special thanks to:
- [Nick Nisi](https://github.com/nicknisi/dotfiles)
- [Christian Chiarulli](https://www.chrisatmachine.com/)
- [Dorian Karter](https://github.com/dkarter/dotfiles)

## ⭐ Show Your Support

If you found this repository helpful, please consider giving it a star! It helps others discover these dotfiles and motivates me to keep improving them.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/jrock2004">John Costanzo</a>
</p>
