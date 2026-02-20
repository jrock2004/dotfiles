# Package Management System

This directory contains the cross-platform package management system for the dotfiles.

## Directory Structure

```
packages/
├── common.txt              # Cross-platform CLI tools (should exist everywhere)
├── optional.txt            # Nice-to-have tools (may not be available on all platforms)
├── macos/
│   ├── core.txt           # macOS-specific packages (Homebrew formulae)
│   ├── gui-apps.txt       # macOS GUI applications (Homebrew casks)
│   ├── fonts.txt          # Nerd fonts and programming fonts
│   ├── macos-only.txt     # macOS-only tools (yabai, skhd, sketchybar)
│   └── taps.txt           # Homebrew taps (custom repositories)
├── linux/
│   ├── core.txt           # Linux-specific packages
│   └── gui-apps.txt       # Linux GUI applications
├── wsl/
│   └── wsl-specific.txt   # WSL-specific additions
└── mappings/
    ├── common-to-ubuntu.map    # Package name mappings for Ubuntu/Debian
    ├── common-to-arch.map      # Package name mappings for Arch
    └── common-to-fedora.map    # Package name mappings for Fedora/RHEL
```

## Package File Format

Each package file is a simple text file with one package name per line:

```
# This is a comment
git
neovim
fzf
```

- Lines starting with `#` are comments
- Empty lines are ignored
- Package names should be simple (no version specifiers)

## Categories

### common.txt
Essential cross-platform CLI tools that should be available on all systems:
- Version control (git, gh)
- Shell utilities (bash, zsh, tmux, fzf)
- File search (fd, ripgrep, eza)
- Text processing (jq, grep)
- Development tools (neovim, vim, make)
- Programming languages (python, go)

### optional.txt
Nice-to-have tools that may not be available on all platforms:
- Advanced CLI tools (ast-grep, chafa, viu)
- Language servers and formatters
- Additional terminal multiplexers (zellij)

### Platform-Specific Files

**macOS:**
- `core.txt`: macOS-specific command-line tools
- `gui-apps.txt`: GUI applications via Homebrew casks
- `fonts.txt`: Nerd fonts and programming fonts
- `macos-only.txt`: Window managers (yabai, skhd), status bars (sketchybar)
- `taps.txt`: Custom Homebrew repositories

**Linux:**
- `core.txt`: Linux distribution packages
- `gui-apps.txt`: Linux GUI applications (via apt, pacman, dnf, or Flatpak/Snap)

**WSL:**
- `wsl-specific.txt`: WSL-specific utilities and configurations

## Mapping Files

Mapping files handle package name differences across platforms. Format:

```
# common-package-name=platform-specific-name
fd=fd-find
bat=batcat
```

## Adding New Packages

1. **Cross-platform tool**: Add to `common.txt`
2. **Optional tool**: Add to `optional.txt`
3. **Platform-specific**: Add to appropriate platform file
4. **Name differs**: Add mapping to `mappings/common-to-*.map`

## Validation

Use the validator script to ensure consistency:

```bash
./scripts/validate-packages.sh
```

This will:
- Check that all common packages have mappings for each platform
- Report missing packages per OS
- Show differences between platforms
- Verify no duplicate packages

## Migration from Brewfile

The old `Brewfile` is kept temporarily for backward compatibility. To migrate:

```bash
./scripts/migrate-brewfile.sh
```

## Future Plans

- Add Windows native support
- Add Nix package manager support
- Add Flatpak/Snap support for Linux GUI apps
- Automated package updates and version management
