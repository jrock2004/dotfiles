# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for macOS that manages system configuration through GNU Stow for symlinking. The setup includes configurations for:
- **Shell**: zsh with Powerlevel10k theme and zap plugin manager
- **Editors**: Neovim (LazyVim), VS Code, Cursor
- **Terminal emulators**: Ghostty, Alacritty, Kitty, WezTerm
- **Window management**: yabai + skhd + sketchybar
- **Terminal multiplexers**: tmux, zellij
- **Version managers**: Volta (Node.js), rustup (Rust)

## Installation & Setup

### Initial Installation
```bash
# Fresh install (from remote)
bash <(curl -L https://raw.githubusercontent.com/jrock2004/dotfiles/main/scripts/curl-install.sh)

# Local install
./install.sh
```

The installer will:
1. Ask for OS choice (Mac OSX only currently supported)
2. Install Homebrew if not present
3. Run `brew bundle` to install all dependencies from Brewfile
4. Set up directories, FZF, Lua, Neovim, Rust, Volta, tmux, and Claude CLI
5. Use Stow to symlink all files from `files/` to `$HOME`

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
├── files/              # All files to be symlinked to $HOME
│   ├── .config/        # XDG config directory
│   │   ├── nvim/       # LazyVim configuration
│   │   ├── ghostty/    # Ghostty terminal config
│   │   ├── sketchybar/ # macOS status bar
│   │   ├── yabai/      # Window manager
│   │   ├── skhd/       # Hotkey daemon
│   │   └── ...         # Other app configs
│   ├── .zshrc          # Main zsh config
│   ├── .zprofile       # Zsh profile
│   ├── .tmux.conf      # Tmux configuration
│   └── ...
├── zsh/
│   ├── functions/      # Autoloaded zsh functions
│   └── utils.zsh       # Shared zsh utilities
├── bin/                # Custom scripts (added to PATH)
│   ├── tm              # Tmux session manager
│   ├── update          # System update script
│   └── ...
├── instructions/       # AI assistant instructions
│   ├── cursor/rules/   # Cursor AI rules
│   └── vscode/         # VS Code Copilot instructions
├── scripts/            # Installation scripts
├── Brewfile            # Homebrew dependencies
└── install.sh          # Main installation script
```

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
- **zap** plugin manager (loaded from `~/.local/share/zap/zap.zsh`)
- **Powerlevel10k** theme (macOS only, via Homebrew)
- Custom functions in `zsh/functions/` (autoloaded)
- Utilities in `zsh/utils.zsh`

Key environment variables:
- `$DOTFILES`: Points to `~/.dotfiles`
- `$VOLTA_HOME`: Volta installation directory
- `$RIPGREP_CONFIG_PATH`: Ripgrep config at `~/.rgrc`
- `$PNPM_HOME`: pnpm global packages

Custom path order (prepended in `.zshrc`):
1. `~/.local/bin`
2. `$HOME/.local/lib/python3.9/site-packages`
3. `$VOLTA_HOME/bin`
4. `$DOTFILES/bin`
5. `/usr/local/sbin`
6. `/usr/local/opt/grep/libexec/gnubin`

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

```bash
# Install via Homebrew (preferred for system tools)
brew install <package>
brew install --cask <app>

# Update Brewfile to persist
brew bundle dump --force

# Install Node packages globally via Volta
volta install <package>

# Or use the alias (installs common language servers)
npmpackages
```

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

```bash
# Update Homebrew and all packages
updateSystem
# Expands to: brew update && brew upgrade && brew doctor

# Or use the bin script
update
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

## Important Notes

- **macOS only**: Currently only supports Mac OSX
- **Stow-based**: Never edit files in `$HOME` directly; edit in `files/` then run `sync`
- **Homebrew**: Main package manager, uses rosetta for Volta/Node compatibility
- **Volta**: Manages Node.js versions (not nvm/fnm)
- **LazyVim**: Base Neovim config - consult LazyVim docs for built-in features
- **Shell**: Uses zsh (not bash), switched automatically during install
- **Git config**: `.gitconfig` is managed via Stow, so user-specific changes should be in `files/.gitconfig`

## Key Dependencies

From Brewfile (91 total packages):
- **Core tools**: git, gh, stow, fzf, ripgrep, fd, eza, bat, jq
- **Languages**: go, python, lua, rust (via rustup)
- **Shells**: zsh, bash, tmux, zellij
- **Editors**: neovim, vim
- **macOS tools**: yabai, skhd, sketchybar
- **Dev tools**: lazygit, lazydocker, prettier, stylua, shellcheck
- **Terminals**: ghostty, alacritty, kitty, wezterm
