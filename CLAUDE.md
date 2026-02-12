# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform dotfiles repository that manages system configuration through GNU Stow for symlinking. The setup includes configurations for:
- **Platforms**: macOS (Intel & ARM), Linux (Ubuntu, Fedora, Arch), WSL (WSL1 & WSL2)
- **Shell**: zsh with Powerlevel10k theme (macOS) or Starship (Linux/WSL), zap plugin manager
- **Editors**: Neovim (LazyVim), VS Code, Cursor
- **Terminal emulators**: Ghostty, Alacritty, Kitty, WezTerm
- **Window management**: yabai + skhd + sketchybar (macOS), i3/sway (Linux)
- **Terminal multiplexers**: tmux, zellij
- **Version managers**: Volta (Node.js), rustup (Rust)
- **Package management**: Cross-platform package system with OS-specific mappings

## Installation & Setup

### Platform Support Matrix

| Platform | Status | Package Manager | Notes |
|----------|--------|----------------|-------|
| macOS (Intel) | ✅ Fully Supported | Homebrew | Main development platform |
| macOS (ARM) | ✅ Fully Supported | Homebrew | Rosetta for compatibility |
| Ubuntu/Debian | ✅ Fully Supported | apt-get | Tested on 20.04+ |
| Fedora/RHEL | ✅ Fully Supported | dnf | Tested on Fedora 38+ |
| Arch Linux | ✅ Fully Supported | pacman | AUR via yay (optional) |
| WSL1/WSL2 | ✅ Fully Supported | apt-get/dnf/pacman | Based on distro |

### Initial Installation

```bash
# Fresh install (from remote) - Auto-detects OS
bash <(curl -L https://raw.githubusercontent.com/jrock2004/dotfiles/main/scripts/curl-install.sh)

# Local install - Interactive mode
./install.sh

# Non-interactive install (CI/automation)
./install.sh --non-interactive

# Dry-run (preview without executing)
./install.sh --dry-run

# Install only specific components
./install.sh --only shell,neovim,tmux

# Skip specific components
./install.sh --skip lua,rust
```

### Installation Process

The modular installer will:
1. **Detect OS and architecture** (macOS/Linux/WSL, Intel/ARM)
2. **Install package manager** if not present (Homebrew/apt/dnf/pacman)
3. **Install packages** from cross-platform package files
4. **Set up components** based on selection (shell, neovim, tmux, rust, volta, etc.)
5. **Configure OS-specific features** (macOS defaults, WSL systemd, etc.)
6. **Symlink dotfiles** using GNU Stow from `files/` to `$HOME`
7. **Create backups** before overwriting existing configs

### CLI Flags

```bash
# Display help
./install.sh --help

# Show version
./install.sh --version

# List all available components
./install.sh --list-components

# Preview actions without executing
./install.sh --dry-run

# Skip all prompts (use defaults)
./install.sh --non-interactive

# Force reinstall even if already installed
./install.sh --force

# Skip specific components
./install.sh --skip <component1>,<component2>

# Install only specific components
./install.sh --only <component1>,<component2>
```

### Configuration File

Create `~/.dotfiles.env` to set default options:

```bash
# Skip specific components
SKIP_COMPONENTS="rust,lua"

# Install only specific components
ONLY_COMPONENTS="shell,neovim"

# Custom backup location
BACKUP_DIR="$HOME/.config/dotfiles-backups"

# Force specific package manager
PACKAGE_MANAGER="brew"  # or apt, dnf, pacman

# Non-interactive mode
NON_INTERACTIVE=true

# Dry-run mode
DRY_RUN=true

# Force reinstall
FORCE_INSTALL=true

# Custom log file
LOG_FILE="$HOME/.dotfiles-install.log"

# Desktop environment flag
USE_DESKTOP_ENV=true

# Override OS detection
OS="linux"  # or macos, wsl
```

See `.dotfiles.env.example` for all available options.

### Managing Dotfiles with Stow

```bash
# Apply/update symlinks (do this after editing files)
sync
# Or: stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files

# Remove symlinks
unsync
# Or: stow --ignore ".DS_Store" -v -D -t ~ -d "$DOTFILES" files
```

**Important**: All configuration files live in `files/` and are symlinked to `$HOME`. When editing configs, always modify files in `files/.config/` or `files/`, never the symlinked versions in `$HOME`.

## Architecture

### Directory Structure

```
.
├── files/                      # All files to be symlinked to $HOME
│   ├── .config/                # XDG config directory
│   │   ├── nvim/               # LazyVim configuration
│   │   ├── ghostty/            # Ghostty terminal config
│   │   ├── sketchybar/         # macOS status bar
│   │   ├── yabai/              # macOS window manager
│   │   ├── skhd/               # macOS hotkey daemon
│   │   ├── starship.toml       # Starship prompt (Linux/WSL)
│   │   └── ...                 # Other app configs
│   ├── .zshrc                  # Main zsh config (OS detection)
│   ├── .zprofile               # Zsh profile
│   ├── .tmux.conf              # Tmux configuration
│   └── ...
├── packages/                   # Cross-platform package management
│   ├── common.txt              # Cross-platform CLI tools
│   ├── optional.txt            # Nice-to-have tools
│   ├── macos/                  # macOS-specific packages
│   │   ├── core.txt            # Homebrew formulae
│   │   ├── gui-apps.txt        # Homebrew casks
│   │   ├── fonts.txt           # Nerd fonts
│   │   ├── macos-only.txt      # Window managers, status bars
│   │   └── taps.txt            # Homebrew taps
│   ├── linux/                  # Linux-specific packages
│   │   ├── core.txt            # Distribution packages
│   │   ├── gui-apps.txt        # Native packages
│   │   ├── gui-apps-flatpak.txt # Flatpak apps
│   │   └── gui-apps-snap.txt   # Snap apps
│   ├── wsl/                    # WSL-specific packages
│   │   └── wsl-specific.txt    # WSL utilities
│   ├── mappings/               # Package name mappings
│   │   ├── common-to-macos.map
│   │   ├── common-to-ubuntu.map
│   │   ├── common-to-arch.map
│   │   └── common-to-fedora.map
│   └── README.md               # Package system documentation
├── scripts/                    # Modular installation scripts
│   ├── install.sh              # Main entry point (339 lines)
│   ├── uninstall.sh            # Uninstall script
│   ├── update.sh               # Update script
│   ├── lib/                    # Shared libraries
│   │   ├── common.sh           # Logging, backup, retry, error handling
│   │   ├── detect.sh           # OS/distro/arch detection
│   │   ├── package-manager.sh  # Package abstraction layer
│   │   ├── ui.sh               # UI functions (colors, symbols)
│   │   └── gum-wrapper.sh      # Interactive prompts with fallbacks
│   ├── os/                     # OS-specific orchestration
│   │   ├── macos.sh            # macOS setup
│   │   ├── linux.sh            # Linux setup
│   │   └── wsl.sh              # WSL setup
│   ├── components/             # Component setup functions
│   │   ├── directories.sh      # Directory creation
│   │   ├── shell.sh            # Shell setup (zsh, zap, FZF)
│   │   ├── neovim.sh           # Neovim dependencies
│   │   ├── tmux.sh             # Tmux plugin manager
│   │   ├── rust.sh             # Rust toolchain
│   │   ├── volta.sh            # Volta/Node setup
│   │   ├── lua.sh              # Lua language server
│   │   ├── claude.sh           # Claude Code CLI
│   │   └── stow.sh             # GNU Stow symlinking
│   ├── validate-packages.sh    # Package consistency validator
│   ├── migrate-brewfile.sh     # Brewfile migration tool
│   ├── test-shellcheck.sh      # ShellCheck linting
│   └── test-integration.sh     # Integration tests
├── test/                       # Docker test environments
│   ├── Dockerfile.ubuntu
│   ├── Dockerfile.fedora
│   ├── Dockerfile.arch
│   └── test-docker.sh
├── .github/workflows/          # CI/CD pipelines
│   └── test-install.yml        # GitHub Actions tests
├── zsh/
│   ├── functions/              # Autoloaded zsh functions
│   └── utils.zsh               # Shared zsh utilities
├── bin/                        # Custom scripts (added to PATH)
│   ├── tm                      # Tmux session manager
│   ├── update                  # System update script
│   └── ...
├── instructions/               # AI assistant instructions
│   ├── cursor/rules/           # Cursor AI rules
│   └── vscode/                 # VS Code Copilot instructions
├── Brewfile                    # Legacy Homebrew (kept for compatibility)
├── install.sh                  # Root wrapper (calls scripts/install.sh)
├── uninstall.sh                # Root wrapper (calls scripts/uninstall.sh)
├── update.sh                   # Root wrapper (calls scripts/update.sh)
├── .dotfiles.env.example       # Configuration file example
├── .shellcheckrc               # ShellCheck configuration
└── tasks.md                    # Development task tracking
```

### Package Management System

The dotfiles use a **cross-platform package management system** that:
- Defines common tools in `packages/common.txt` (should exist on all platforms)
- Defines optional tools in `packages/optional.txt` (nice-to-have)
- Uses OS-specific package files for platform-specific tools
- Maps package names across platforms via `packages/mappings/*.map`
- Validates package consistency with `scripts/validate-packages.sh`

**Package abstraction layer** (`scripts/lib/package-manager.sh`):
- `pkg_install()`: Installs packages using appropriate package manager
- `pkg_update()`: Updates all packages
- Supports: Homebrew, apt-get, dnf, pacman, flatpak, snap
- Handles package name lookups via mapping files
- Gracefully handles optional packages (warns but continues)

**Example**: Installing `fd` (file search tool)
- macOS: `brew install fd`
- Ubuntu: `apt-get install fd-find` (mapped via `common-to-ubuntu.map`)
- Arch: `pacman -S fd`
- Fedora: `dnf install fd-find`

### Component-Based Architecture

The installation system is **modular and component-based**:

**Available Components**:
- `directories`: Create standard directories (~/.local/bin, ~/projects, etc.)
- `homebrew`: Install Homebrew and packages (macOS)
- `vscode`: Install VS Code extensions
- `fonts`: Install Nerd Fonts
- `claude`: Install Claude Code CLI
- `fzf`: Install FZF (fuzzy finder)
- `lua`: Install Lua language server
- `neovim`: Install Neovim dependencies (pynvim)
- `rust`: Install Rust toolchain (rustup)
- `shell`: Configure zsh, zap plugin manager
- `tmux`: Install Tmux Plugin Manager (tpm)
- `volta`: Install Volta and Node.js
- `stow`: Symlink dotfiles with GNU Stow
- `macos-defaults`: Configure macOS defaults (macOS only)

**Component Dependencies**:
```
directories → none
shell → git, curl, zsh, brew (optional)
neovim → python, pip
tmux → git, curl
rust → curl, bash
volta → curl, bash
lua → git, curl, luarocks (optional)
claude → curl, bash
stow → stow
```

Components are **idempotent** (safe to run multiple times) and include:
- Pre-installation checks (skip if already installed)
- Retry logic for network operations
- Rollback on failure
- Progress tracking
- Detailed logging

### OS Detection and Platform-Specific Setup

**Detection** (`scripts/lib/detect.sh`):
- Detects OS: macOS, Linux, WSL
- Detects distro: Ubuntu, Debian, Fedora, Arch, etc.
- Detects architecture: x86_64, arm64, aarch64
- Exports: `$OS`, `$DISTRO`, `$ARCH`, `$BREW_PREFIX`, `$IS_WSL`

**Platform Orchestration** (`scripts/os/*.sh`):
- **macOS** (`os/macos.sh`): Xcode CLI tools, Homebrew, Rosetta (ARM)
- **Linux** (`os/linux.sh`): Build tools, package manager setup, Starship
- **WSL** (`os/wsl.sh`): systemd, Windows interop, clipboard integration

**Conditional Configuration**:
- `.zshrc` detects OS and loads appropriate theme (Powerlevel10k vs Starship)
- Stow skips platform-specific configs (e.g., yabai on Linux, i3 on macOS)
- Package installation uses OS-appropriate package manager
- Fonts installed differently (Homebrew on macOS, ~/.local/share/fonts on Linux)

### Neovim Configuration

Uses **LazyVim** as the base configuration with custom plugins and overrides:
- Plugin manager: lazy.nvim (bootstrapped in `files/.config/nvim/lua/config/lazy.lua`)
- Base: LazyVim plugins imported from `"lazyvim.plugins"`
- Custom plugins: `files/.config/nvim/lua/plugins/` (auto-loaded)
- Config: `files/.config/nvim/lua/config/` (options, keymaps, autocmds)

Key files:
- `init.lua`: Entry point, just requires `config.lazy`
- `lua/config/lazy.lua`: Sets up lazy.nvim and plugin loading
- `lua/config/options.lua`: Vim options
- `lua/config/keymaps.lua`: Custom keybindings
- `lua/config/autocmds.lua`: Autocommands
- `lua/plugins/*.lua`: Plugin configurations (copilot-chat, colorscheme, lualine, etc.)

### Shell Configuration

The shell setup uses:
- **zap** plugin manager (installed in `~/.local/share/zap/zap.zsh`)
- **Powerlevel10k** theme (macOS only, via Homebrew)
- **Starship** prompt (Linux/WSL, cross-platform)
- Custom functions in `zsh/functions/` (autoloaded)
- Utilities in `zsh/utils.zsh`

Key environment variables:
- `$DOTFILES`: Points to `~/.dotfiles`
- `$VOLTA_HOME`: Volta installation directory
- `$RIPGREP_CONFIG_PATH`: Ripgrep config at `~/.rgrc`
- `$PNPM_HOME`: pnpm global packages
- `$OS`: Detected operating system
- `$DISTRO`: Linux distribution (if applicable)

Custom path order (prepended in `.zshrc`):
1. `~/.local/bin`
2. `$HOME/.local/lib/python3.9/site-packages`
3. `$VOLTA_HOME/bin`
4. `$DOTFILES/bin`
5. `/usr/local/sbin`
6. `/usr/local/opt/grep/libexec/gnubin` (macOS)

### UI/UX Library

The installer includes a UI library (`scripts/lib/ui.sh` and `scripts/lib/gum-wrapper.sh`) that:
- Uses **gum** if available (optional dependency)
- Falls back to **fzf** or **bash select** if gum not installed
- Provides colored output, symbols (✓, ✗, →, ℹ, ⚠)
- Implements progress bars and spinners
- Handles interactive prompts with graceful fallbacks

**Wrapper functions**:
- `ui_choose()`: Single selection (gum choose → fzf → select)
- `ui_multi_select()`: Multi-selection (gum choose --no-limit → fzf --multi)
- `ui_confirm()`: Yes/no prompts (gum confirm → read -p)
- `ui_input()`: Text input (gum input → read -p)
- `ui_spin()`: Spinner for background tasks

All prompts are skipped when `--non-interactive` flag is set.

### Error Handling and Reliability

**Error Handling** (`scripts/lib/common.sh`):
- `set -euo pipefail` in all scripts (exit on error, undefined vars, pipe failures)
- `trap` for cleanup on error (ERR, EXIT, INT, TERM signals)
- `error_handler()`: Logs errors with stack trace
- `cleanup_on_error()`: Automatic rollback to backups

**Backup System**:
- Backups created before overwriting configs
- Timestamp-based backup directories: `~/.dotfiles.backup.<timestamp>`
- Automatic restore if installation fails
- Manual restore with `restore_backup()` function

**Retry Logic**:
- Network operations (curl, git clone) retry up to 3 times
- Exponential backoff between retries
- `retry_command()` wrapper function in common.sh

**Logging**:
- `log_info()`, `log_success()`, `log_warning()`, `log_error()`
- Timestamps on all log messages
- Optional log file via `LOG_FILE` env variable
- Progress tracking (e.g., "Step 3/10")

### Testing Infrastructure

**Testing Tools**:
- **ShellCheck**: All 27 scripts pass shellcheck validation
- **Integration tests**: `scripts/test-integration.sh` (verifies installation)
- **Docker tests**: `test/test-docker.sh` (Ubuntu, Fedora, Arch containers)
- **CI/CD**: GitHub Actions (`.github/workflows/test-install.yml`)

**Running Tests**:
```bash
# ShellCheck linting
./scripts/test-shellcheck.sh

# Integration tests
./scripts/test-integration.sh

# Docker tests (Ubuntu)
./test/test-docker.sh ubuntu

# Docker tests (all distros)
./test/test-docker.sh ubuntu fedora arch
```

**CI Pipeline**:
- Tests on macOS-latest
- Tests on ubuntu-latest
- Dry-run and non-interactive tests
- Full installation test on Ubuntu
- Package validation
- Help/version flag tests

### AI Assistant Instructions

This repository includes instruction files for AI coding assistants:

**VS Code Copilot** (`instructions/vscode/copilot-instructions.md`):
- TypeScript/React development rules
- Testing with Vitest, React Testing Library, MSW
- Strict typing (no `any`, use discriminated unions)
- Accessibility requirements
- Critical review mode enabled

**Cursor AI** (`instructions/cursor/rules/*.mdc`):
- Same rules as VS Code, split into modular files
- Categories: typescript-style, react-style, testing, msw-testing, accessibility, etc.

When working on TypeScript/React code, follow these guidelines from the instructions.

## Common Tasks

### Installing New Packages

**Cross-platform tools** (should work on all OSes):
```bash
# Add to packages/common.txt
echo "newtool" >> packages/common.txt

# Add platform-specific name mappings if needed
echo "newtool=newtool-bin" >> packages/mappings/common-to-ubuntu.map

# Validate
./scripts/validate-packages.sh

# Install
./scripts/install.sh --only homebrew
```

**macOS-only tools**:
```bash
# Add to appropriate file
echo "package-name" >> packages/macos/core.txt           # CLI tool
echo "app-name" >> packages/macos/gui-apps.txt           # GUI app (cask)
echo "font-name" >> packages/macos/fonts.txt             # Font
echo "yabai" >> packages/macos/macos-only.txt            # macOS-specific

# For Homebrew taps
echo "homebrew/cask-fonts" >> packages/macos/taps.txt

# Reinstall packages
./scripts/install.sh --only homebrew --force
```

**Linux-only tools**:
```bash
# Add to appropriate file
echo "package-name" >> packages/linux/core.txt           # Distribution package
echo "flatpak-id" >> packages/linux/gui-apps-flatpak.txt # Flatpak
echo "snap-name" >> packages/linux/gui-apps-snap.txt     # Snap

# Reinstall
./scripts/install.sh --only homebrew --force
```

**Node packages via Volta**:
```bash
# Install globally via Volta
volta install <package>

# Or use the alias (installs common language servers)
npmpackages
```

**Migrating from old Brewfile**:
```bash
# Run migration script
./scripts/migrate-brewfile.sh

# Validates mapping and reports differences
```

### Package Validation

```bash
# Validate package consistency
./scripts/validate-packages.sh

# This checks:
# - All common packages have mappings for each platform
# - No duplicate packages across files
# - Package name format is correct
# - Reports missing packages per OS
```

### Updating Dotfiles

```bash
# Pull latest changes and re-apply
./update.sh

# Update without updating packages
./update.sh --no-packages

# Update without restarting services
./update.sh --no-restart

# Preview update without executing
./update.sh --dry-run
```

The update script will:
1. Show git diff of changes
2. Pull latest changes from git
3. Optionally update installed packages
4. Re-run stow for new configs
5. Optionally restart services (tmux, yabai, etc.)
6. Create backup before updating

### Uninstalling

```bash
# Remove dotfile symlinks only
./uninstall.sh

# Remove symlinks and installed packages
./uninstall.sh --remove-packages

# Preview what would be removed
./uninstall.sh --dry-run
```

The uninstall script will:
1. Show confirmation prompt
2. Backup current configs
3. Remove symlinks via stow
4. Optionally remove installed packages
5. Provide rollback instructions

### Testing Neovim Changes

```bash
# Just edit files in files/.config/nvim/ - changes apply immediately
nvim

# Test with alternate config
NVIM_APPNAME=ownnvim nvim  # or use alias: vim2
```

### Tmux Session Management

```bash
# Interactive session selector
tm

# Create/attach to work session
tmux-work  # or zellij-work for zellij
```

### System Updates

**macOS**:
```bash
# Update Homebrew and all packages
updateSystem
# Expands to: brew update && brew upgrade && brew doctor

# Or use the bin script
update
```

**Linux (Ubuntu/Debian)**:
```bash
# Update apt packages
sudo apt update && sudo apt upgrade

# Or use the update script
./update.sh
```

**Linux (Arch)**:
```bash
# Update pacman packages
sudo pacman -Syu

# Update AUR packages (if using yay)
yay -Syu
```

**Linux (Fedora)**:
```bash
# Update dnf packages
sudo dnf update

# Or use the update script
./update.sh
```

### Git Aliases

Available in `.zshrc`:
- `gs` → `git status`
- `glog` → `git l` (custom log format)
- `gcorb` → Checkout remote branch (fzf selector)
- `gcob` → Checkout local branch (fzf selector)
- `gpo` → `git pull origin`

### Package Manager Switching

```bash
# Switch between npm/yarn/pnpm (nukes node_modules and lock files)
switchtoyarn
switchtopnpm
switchtonpm
```

### Running Tests

```bash
# Run ShellCheck on all scripts
./scripts/test-shellcheck.sh

# Run integration tests
./scripts/test-integration.sh

# Test in Docker (Ubuntu)
./test/test-docker.sh ubuntu --build

# Test in all distros
for distro in ubuntu fedora arch; do
    ./test/test-docker.sh "$distro" --build
done
```

### Dry-Run Mode

```bash
# Preview installation without executing
./install.sh --dry-run

# Preview update without executing
./update.sh --dry-run

# Preview uninstall without executing
./uninstall.sh --dry-run
```

## Platform-Specific Notes

### macOS

**Prerequisites**:
- Xcode Command Line Tools (installed automatically)
- Rosetta 2 (ARM Macs, installed automatically if needed)

**macOS-specific features**:
- Homebrew package manager
- yabai window manager
- skhd hotkey daemon
- sketchybar status bar
- Powerlevel10k zsh theme
- macOS defaults configuration

**Installation**:
```bash
./install.sh
```

### Linux (Ubuntu/Debian)

**Prerequisites**:
```bash
sudo apt-get update
sudo apt-get install -y git curl build-essential
```

**Linux-specific features**:
- apt-get package manager
- Starship prompt
- Optional: i3/sway window manager
- Optional: Flatpak/Snap for GUI apps

**Installation**:
```bash
./install.sh --non-interactive
```

### Linux (Fedora/RHEL)

**Prerequisites**:
```bash
sudo dnf update
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y git curl
```

**Installation**:
```bash
./install.sh --non-interactive
```

### Linux (Arch)

**Prerequisites**:
```bash
sudo pacman -Syu
sudo pacman -S --needed base-devel git curl
```

**Optional AUR helper**:
```bash
# Install yay for AUR packages
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

**Installation**:
```bash
./install.sh --non-interactive
```

### WSL (Windows Subsystem for Linux)

**Prerequisites**:
- WSL2 recommended (better performance)
- Base distro installed (Ubuntu, Fedora, or Arch)

**WSL-specific setup**:
- systemd enabled (WSL2 only)
- Windows interop configured
- Clipboard integration (`clip.exe`)
- BROWSER env variable set to Windows browser

**Installation**:
```bash
./install.sh --non-interactive
```

**WSL notes**:
- Desktop environment configs (yabai, i3) are skipped
- Audio configs are skipped
- Uses distro's native package manager
- Optional Windows Terminal integration

## Troubleshooting

### Common Issues

**"Command not found" after installation**:
```bash
# Reload shell configuration
exec zsh

# Or source manually
source ~/.zshrc
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
chmod +x scripts/lib/*.sh
chmod +x scripts/os/*.sh
chmod +x scripts/components/*.sh
```

**Git clone fails due to network**:
```bash
# Retry with force
./install.sh --force

# Or manually retry
cd ~/.dotfiles
git pull origin main
./install.sh
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

**Python dependencies missing (Neovim)**:
```bash
# Install pynvim
python3 -m pip install --user pynvim

# Or use the installer
./install.sh --only neovim --force
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

### Platform-Specific Troubleshooting

**macOS**:
- See `docs/MACOS.md` (when created)
- Rosetta issues on ARM: `softwareupdate --install-rosetta --agree-to-license`
- Xcode issues: `sudo xcode-select --reset`

**Linux**:
- See `docs/LINUX.md` (when created)
- Font cache issues: `fc-cache -fv`
- Shell not changed: `chsh -s $(which zsh)`

**WSL**:
- See `docs/WSL.md` (when created)
- Clock drift: `sudo hwclock -s`
- Clipboard issues: Ensure `clip.exe` is in PATH

### Getting Help

```bash
# Show help
./install.sh --help

# Check version
./install.sh --version

# List components
./install.sh --list-components

# Preview what would be installed
./install.sh --dry-run

# Check logs
tail -f ~/.dotfiles-install.log
```

## Important Notes

- **Cross-platform**: Supports macOS, Linux (Ubuntu, Fedora, Arch), and WSL
- **Stow-based**: Never edit files in `$HOME` directly; edit in `files/` then run `sync`
- **Package managers**: Homebrew (macOS), apt/dnf/pacman (Linux), automatic detection
- **Volta**: Manages Node.js versions (not nvm/fnm)
- **LazyVim**: Base Neovim config - consult LazyVim docs for built-in features
- **Shell**: Uses zsh (not bash), switched automatically during install
- **Git config**: `.gitconfig` is managed via Stow, so user-specific changes should be in `files/.gitconfig`
- **Modular**: Component-based architecture, skip or install only what you need
- **Idempotent**: Safe to run multiple times, includes rollback on failure
- **Tested**: CI/CD pipeline, Docker tests, integration tests, ShellCheck validation

## Migration from Old System

If upgrading from the old monolithic install.sh:

1. **Backup your current setup**:
   ```bash
   cp -r ~/.dotfiles ~/.dotfiles.backup.old
   ```

2. **Pull latest changes**:
   ```bash
   cd ~/.dotfiles
   git pull origin main
   ```

3. **Review breaking changes** (see `MIGRATION.md` when created)

4. **Run new installer**:
   ```bash
   ./install.sh --dry-run  # Preview first
   ./install.sh            # Then install
   ```

5. **Migrate Brewfile** (macOS only):
   ```bash
   ./scripts/migrate-brewfile.sh
   ```

The old `Brewfile` is kept for backward compatibility but will be deprecated in a future release.

## Key Dependencies

From package files (cross-platform):
- **Core tools** (common.txt): git, gh, stow, fzf, ripgrep, fd, eza, bat, jq
- **Languages** (common.txt): go, python, lua, rust (via rustup)
- **Shells** (common.txt): zsh, bash, tmux
- **Editors** (common.txt): neovim, vim
- **Dev tools** (optional.txt): lazygit, lazydocker, prettier, stylua, shellcheck

**macOS-specific** (packages/macos/):
- Window managers: yabai, skhd, sketchybar
- Terminals: ghostty, alacritty, kitty, wezterm
- Fonts: Nerd Fonts via Homebrew casks

**Linux-specific** (packages/linux/):
- Window managers: i3, sway (optional)
- Terminals: alacritty, kitty (via Flatpak/Snap)
- Fonts: Nerd Fonts from GitHub releases

**Total packages**: ~100+ packages across all platforms

## Development

### Adding New Components

1. Create component file in `scripts/components/<name>.sh`
2. Define `setup_<name>()` function
3. Add component to `show_help()` in `scripts/install.sh`
4. Add component to OS orchestration script (`scripts/os/*.sh`)
5. Add dependencies to component file header
6. Test with `./install.sh --only <name> --dry-run`

### Running Development Tests

```bash
# ShellCheck all scripts
./scripts/test-shellcheck.sh

# Integration tests
./scripts/test-integration.sh

# Docker tests
./test/test-docker.sh ubuntu --build --shell

# CI locally (requires act)
act -j test-macos
act -j test-ubuntu
```

### Code Style

- All scripts use `set -euo pipefail`
- Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Pass ShellCheck with no warnings
- Include error handling and logging
- Make functions idempotent
- Add progress tracking for long operations
- Include `--dry-run` support
- Document dependencies in file header

### Contributing

See `CONTRIBUTING.md` (when created) for detailed contribution guidelines.

## Version History

- **v2.0.0** (Current): Cross-platform support, modular architecture, package system
- **v1.x.x**: macOS-only, monolithic install.sh, Brewfile-based

## License

See LICENSE file in repository root.
