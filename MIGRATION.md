# Migration Guide

This guide will help you migrate from the old monolithic dotfiles system (v1.x.x) to the new modular, cross-platform architecture (v2.0.0).

## Table of Contents

- [What's Changed](#whats-changed)
- [Breaking Changes](#breaking-changes)
- [Before You Migrate](#before-you-migrate)
- [Migration Steps](#migration-steps)
- [Brewfile to Packages Migration](#brewfile-to-packages-migration)
- [Configuration Changes](#configuration-changes)
- [Rollback Instructions](#rollback-instructions)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

## What's Changed

### Version 2.0.0 (Current)

The new version introduces a **modular, component-based architecture** with **cross-platform support**:

#### Major Improvements

1. **Cross-Platform Support**
   - **Old**: macOS only
   - **New**: macOS, Ubuntu, Fedora, Arch Linux, WSL

2. **Package Management**
   - **Old**: Single `Brewfile` (Homebrew only)
   - **New**: Cross-platform package system with mappings
     - `packages/common.txt` - Cross-platform tools
     - `packages/optional.txt` - Optional tools
     - `packages/macos/` - macOS-specific packages
     - `packages/linux/` - Linux-specific packages
     - `packages/wsl/` - WSL-specific packages
     - `packages/mappings/` - Package name mappings

3. **Installation System**
   - **Old**: Monolithic `install.sh` (1159 lines)
   - **New**: Modular architecture (339-line main script + components)
     - `scripts/lib/` - Shared libraries
     - `scripts/os/` - OS-specific orchestration
     - `scripts/components/` - Component setup functions

4. **New Features**
   - Component-based installation (install only what you need)
   - Dry-run mode (`--dry-run`)
   - Non-interactive mode (`--non-interactive`)
   - Selective installation (`--only`, `--skip`)
   - Configuration file support (`~/.dotfiles.env`)
   - Automatic backups and rollback on failure
   - Update script (`./update.sh`)
   - Uninstall script (`./uninstall.sh`)
   - Package validation (`./scripts/validate-packages.sh`)

5. **Testing & CI**
   - **Old**: No automated testing
   - **New**: ShellCheck, integration tests, Docker tests, GitHub Actions CI

## Breaking Changes

### 1. Installation Command Location

**Old**:
```bash
./install.sh  # Monolithic script in root
```

**New**:
```bash
./install.sh  # Wrapper that calls scripts/install.sh
# Or directly:
./scripts/install.sh
```

**Impact**: Minimal - root wrapper maintained for backward compatibility

### 2. Package Management

**Old**:
```bash
# Single Brewfile
brew bundle dump --force
```

**New**:
```bash
# Multiple package files
echo "package" >> packages/common.txt
./scripts/validate-packages.sh
```

**Impact**: Moderate - see [Brewfile to Packages Migration](#brewfile-to-packages-migration)

### 3. Environment Variables

**New variables** available:
- `$OS` - Detected operating system (macos, linux, wsl)
- `$DISTRO` - Linux distribution (ubuntu, fedora, arch, etc.)
- `$ARCH` - Architecture (x86_64, arm64, aarch64)
- `$IS_WSL` - WSL detection flag

**Impact**: Minimal - backward compatible

### 4. Component Installation

**Old**:
```bash
# All components installed by default
./install.sh
```

**New**:
```bash
# Interactive component selection
./install.sh

# Or selective installation
./install.sh --only shell,neovim,tmux
./install.sh --skip lua,rust
```

**Impact**: Positive - more control over what gets installed

### 5. Configuration Files

**Old**:
```bash
# No configuration file support
# All settings via prompts
```

**New**:
```bash
# Optional configuration file
~/.dotfiles.env
```

**Impact**: Positive - can automate installation

### 6. Shell Theme

**macOS**: No change - still uses Powerlevel10k

**Linux/WSL**: Now uses **Starship** instead of attempting Powerlevel10k

**Impact**: Moderate for Linux users - may need to reconfigure prompt preferences

## Before You Migrate

### 1. Backup Your Current Setup

**Critical**: Always backup before migrating!

```bash
# Backup entire dotfiles directory
cp -r ~/.dotfiles ~/.dotfiles.backup.v1
tar -czf ~/dotfiles-backup-$(date +%Y%m%d).tar.gz ~/.dotfiles

# Backup important configs
cp ~/.zshrc ~/.zshrc.backup
cp ~/.tmux.conf ~/.tmux.conf.backup
cp ~/.config/nvim ~/.config/nvim.backup -r
```

### 2. Note Your Customizations

Document any custom changes you've made:

```bash
# Check for uncommitted changes
cd ~/.dotfiles
git status
git diff

# Note any custom packages in Brewfile
diff Brewfile <(brew bundle dump --file=/dev/stdout)
```

### 3. Check Disk Space

Ensure sufficient space for backups:

```bash
df -h ~
# Need at least 1GB free
```

### 4. Review Prerequisites

Ensure you have required tools:

```bash
# macOS
xcode-select -p

# Linux
git --version
curl --version
```

## Migration Steps

### Step 1: Backup (Required)

```bash
# Navigate to dotfiles
cd ~/.dotfiles

# Create backup
cp -r ~/.dotfiles ~/.dotfiles.backup.v1

# Note current commit
git log -1 --oneline > ~/dotfiles-migration-commit.txt
```

### Step 2: Pull Latest Changes

```bash
# Fetch latest version
git fetch origin

# Checkout main branch
git checkout main

# Pull latest (v2.0.0)
git pull origin main
```

### Step 3: Review Changes

```bash
# See what changed
git log --oneline $(cat ~/dotfiles-migration-commit.txt | cut -d' ' -f1)..HEAD

# Preview new structure
tree -L 2 packages/
tree -L 2 scripts/
```

### Step 4: Dry-Run Installation

**Important**: Always dry-run first!

```bash
# Preview what would be installed
./install.sh --dry-run

# Preview with specific components only
./install.sh --only shell,neovim --dry-run
```

### Step 5: Run Migration

#### Option A: Full Installation (Recommended)

```bash
# Run new installer
./install.sh

# Follow interactive prompts
# Select components you want
```

#### Option B: Non-Interactive

```bash
# Use defaults, no prompts
./install.sh --non-interactive
```

#### Option C: Selective Installation

```bash
# Install only specific components
./install.sh --only shell,neovim,tmux,volta,stow

# Or skip components you don't want
./install.sh --skip lua,rust,claude
```

### Step 6: Migrate Brewfile (macOS Only)

If you have custom packages in your Brewfile:

```bash
# Run migration script
./scripts/migrate-brewfile.sh

# This will:
# - Read your current Brewfile
# - Map packages to new package files
# - Report any unmapped packages
# - Show suggested package file locations
```

**Manually review** the migration:

```bash
# Check what got migrated
diff Brewfile packages/macos/core.txt
cat packages/macos/gui-apps.txt
cat packages/macos/fonts.txt

# Add any missing custom packages
echo "my-custom-package" >> packages/macos/core.txt
```

### Step 7: Validate Configuration

```bash
# Validate package consistency
./scripts/validate-packages.sh

# Check for conflicts
stow -n -v -R -t ~ -d "$DOTFILES" files
```

### Step 8: Test Installation

```bash
# Reload shell
exec zsh

# Test commands
nvim --version
tmux -V
volta --version
git --version

# Check dotfiles are symlinked
ls -la ~/. | grep "\.dotfiles"
```

### Step 9: Verify Everything Works

**Test checklist**:
- [ ] Shell starts without errors
- [ ] Neovim opens and plugins load
- [ ] Tmux starts and plugins work
- [ ] Git configured correctly
- [ ] Volta/Node.js available
- [ ] Custom aliases/functions work
- [ ] Terminal theme looks correct

## Brewfile to Packages Migration

### Understanding the New Structure

**Old**: Single `Brewfile`
```ruby
# Brewfile
brew "git"
brew "neovim"
cask "ghostty"
cask "font-meslo-lg-nerd-font"
```

**New**: Multiple package files
```
packages/
├── common.txt         # git, neovim (cross-platform)
├── macos/
│   ├── core.txt      # macOS-specific CLI tools
│   ├── gui-apps.txt  # ghostty (GUI apps)
│   └── fonts.txt     # font-meslo-lg-nerd-font
```

### Automated Migration

```bash
# Run migration script
./scripts/migrate-brewfile.sh

# Review output
# - Shows where each package was categorized
# - Reports unmapped packages
# - Suggests manual additions
```

### Manual Migration

If you prefer manual control:

#### 1. Export Current Packages

```bash
# Get current Homebrew packages
brew leaves > ~/brew-packages.txt
brew list --cask > ~/brew-casks.txt
```

#### 2. Categorize Packages

**Cross-platform CLI tools** → `packages/common.txt`:
```bash
# Examples: git, neovim, fzf, ripgrep
# These should work on Linux too
```

**macOS-only CLI tools** → `packages/macos/core.txt`:
```bash
# Examples: m-cli, trash, mas
# These are macOS-specific
```

**GUI applications** → `packages/macos/gui-apps.txt`:
```bash
# Examples: ghostty, alacritty, visual-studio-code
# These are Homebrew casks
```

**Fonts** → `packages/macos/fonts.txt`:
```bash
# Examples: font-meslo-lg-nerd-font
# These are font casks
```

**Window managers** → `packages/macos/macos-only.txt`:
```bash
# Examples: yabai, skhd, sketchybar
# macOS-specific system tools
```

#### 3. Add Custom Packages

```bash
# Add your custom packages to appropriate files
echo "my-custom-tool" >> packages/macos/core.txt
echo "my-custom-app" >> packages/macos/gui-apps.txt
```

#### 4. Validate

```bash
./scripts/validate-packages.sh
```

### Keeping Brewfile Temporarily

The old `Brewfile` is **kept for backward compatibility** during the transition:

```bash
# You can still use Brewfile
brew bundle install

# But new system is recommended
./install.sh --only homebrew --force
```

**Deprecation timeline**:
- **v2.0.0 - v2.2.0**: Brewfile kept, both systems work
- **v2.3.0+**: Brewfile will be removed (planned)

## Configuration Changes

### Configuration File Support

**New**: Create `~/.dotfiles.env` to set defaults:

```bash
# Example ~/.dotfiles.env
SKIP_COMPONENTS="rust,lua"
ONLY_COMPONENTS="shell,neovim"
NON_INTERACTIVE=true
BACKUP_DIR="$HOME/.config/dotfiles-backups"
```

See `.dotfiles.env.example` for all options.

### Platform Detection

The new system auto-detects your platform:

```bash
# In .zshrc, configs, etc.
if [[ "$OS" == "macos" ]]; then
    # macOS-specific config
elif [[ "$OS" == "linux" ]]; then
    # Linux-specific config
fi
```

### Conditional Stowing

Platform-specific configs are automatically skipped:

- **macOS**: yabai, skhd, sketchybar configs are used
- **Linux**: i3, rofi configs are used (if present)
- **WSL**: Desktop environment configs are skipped

## Rollback Instructions

If something goes wrong, you can rollback to the old version.

### Quick Rollback

```bash
# Stop if something breaks
cd ~/.dotfiles

# Restore backup
rm -rf ~/.dotfiles
mv ~/.dotfiles.backup.v1 ~/.dotfiles

# Restore configs
cp ~/.zshrc.backup ~/.zshrc
cp ~/.tmux.conf.backup ~/.tmux.conf

# Reload shell
exec zsh
```

### Detailed Rollback

#### 1. Restore Dotfiles Repository

```bash
cd ~/.dotfiles

# Find commit before migration
git log --oneline
# Note the commit hash before v2.0.0

# Reset to old version
git reset --hard <commit-hash>

# Or restore from backup
cd ~
rm -rf ~/.dotfiles
mv ~/.dotfiles.backup.v1 ~/.dotfiles
```

#### 2. Restore Symlinks

```bash
# Remove new symlinks
cd ~/.dotfiles
stow -D -t ~ -d "$DOTFILES" files

# Restore old symlinks (if different)
stow -R -t ~ -d "$DOTFILES" files
```

#### 3. Restore Packages

```bash
# macOS: Use old Brewfile
cd ~/.dotfiles
brew bundle install

# Clean up any v2.0.0 packages
# (optional, only if you want to remove new packages)
```

#### 4. Verify Rollback

```bash
# Check git version
cd ~/.dotfiles
git log -1 --oneline

# Test shell
exec zsh

# Test commands
nvim --version
tmux -V
```

### Reporting Issues

If you had to rollback, please report the issue:

```bash
# Include:
# - OS and version
# - Error messages
# - Steps that led to the problem
# - Contents of ~/.dotfiles-install.log (if exists)
```

[Open an issue on GitHub](https://github.com/jrock2004/dotfiles/issues)

## Troubleshooting

### Issue: "Command not found" after migration

**Solution**:
```bash
# Reload shell configuration
exec zsh

# Or source manually
source ~/.zshrc

# Check PATH
echo $PATH
```

### Issue: Stow conflicts

**Symptom**: `WARNING! stowing files would cause conflicts`

**Solution**:
```bash
# Backup conflicting files
mv ~/.zshrc ~/.zshrc.old
mv ~/.tmux.conf ~/.tmux.conf.old

# Re-run stow
./install.sh --only stow --force
```

### Issue: Missing packages after migration

**Symptom**: Some tools not installed

**Solution**:
```bash
# Check what packages were migrated
./scripts/validate-packages.sh

# Manually add missing packages
echo "missing-package" >> packages/macos/core.txt

# Reinstall
./install.sh --only homebrew --force
```

### Issue: Brewfile migration fails

**Symptom**: `migrate-brewfile.sh` reports errors

**Solution**:
```bash
# Manual migration
# 1. List current packages
brew leaves > ~/packages.txt

# 2. Categorize manually
# 3. Add to appropriate package files

# 4. Validate
./scripts/validate-packages.sh
```

### Issue: Neovim plugins broken

**Symptom**: Neovim errors on startup

**Solution**:
```bash
# Remove plugin cache
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim

# Reinstall plugins
nvim --headless "+Lazy! sync" +qa

# Or use setup component
./install.sh --only neovim --force
```

### Issue: Tmux plugins missing

**Symptom**: Tmux plugins not loading

**Solution**:
```bash
# Reinstall TPM
./install.sh --only tmux --force

# Install plugins
tmux
# Press: Ctrl-b + I (capital I)
```

### Issue: Shell theme broken

**Symptom**: Prompt looks wrong

**macOS**:
```bash
# Reconfigure Powerlevel10k
p10k configure
```

**Linux/WSL**:
```bash
# Check Starship config
cat ~/.config/starship.toml

# Reinstall Starship
curl -sS https://starship.rs/install.sh | sh
```

## FAQ

### Q: Do I need to migrate?

**A**: Not immediately, but recommended for:
- Cross-platform support
- New features (dry-run, selective install, etc.)
- Better error handling and reliability
- Future updates and improvements

### Q: Can I keep using the old Brewfile?

**A**: Yes, for now. Brewfile is kept for backward compatibility but will be deprecated in a future version (v2.3.0+).

### Q: Will my customizations be lost?

**A**: No, if you:
1. Backup before migrating
2. Review your custom changes (`git status`, `git diff`)
3. Re-apply customizations after migration
4. Add custom packages to new package files

### Q: How long does migration take?

**A**:
- Dry-run: 1-2 minutes
- Full migration: 10-30 minutes
- With manual package review: 30-60 minutes

### Q: Can I migrate incrementally?

**A**: Yes! Use selective installation:

```bash
# Migrate shell first
./install.sh --only shell

# Then neovim
./install.sh --only neovim

# Continue with other components
./install.sh --only tmux,volta,stow
```

### Q: What if I'm on Linux, not macOS?

**A**: Great! The new system fully supports Linux:

```bash
# Ubuntu
./install.sh --non-interactive

# Fedora
./install.sh --non-interactive

# Arch
./install.sh --non-interactive
```

Packages will be installed via apt/dnf/pacman automatically.

### Q: Will this break my current setup?

**A**: Not if you:
1. Backup first
2. Use dry-run mode
3. Test before committing
4. Follow rollback instructions if needed

The installer creates automatic backups before overwriting configs.

### Q: Can I use v2.0.0 on multiple machines?

**A**: Yes! That's one of the benefits:

```bash
# Machine 1 (macOS)
./install.sh --non-interactive

# Machine 2 (Linux)
./install.sh --non-interactive

# Same dotfiles, different platform detection
```

### Q: Where can I get help?

**A**:
- Check this migration guide
- Read `README.md` for usage
- Check `CLAUDE.md` for detailed architecture
- Open GitHub issue for bugs
- Check existing issues for solutions

## Success Checklist

After migration, verify these are working:

- [ ] Shell starts without errors
- [ ] Prompt theme displays correctly
- [ ] Neovim opens and plugins load
- [ ] Tmux starts and plugins work
- [ ] Git configured with your info
- [ ] Node.js available via Volta
- [ ] All custom aliases work
- [ ] All custom functions work
- [ ] Window manager works (if using)
- [ ] Terminal emulator configured correctly
- [ ] No error messages in logs
- [ ] Can edit files in `files/` and run `sync`
- [ ] `./update.sh --dry-run` works
- [ ] `./uninstall.sh --dry-run` works

## Next Steps

After successful migration:

1. **Star the repository** on GitHub (if helpful)
2. **Share feedback** via issues or discussions
3. **Contribute improvements** (see CONTRIBUTING.md)
4. **Set up other machines** with the new system
5. **Explore new features**:
   - Try dry-run mode
   - Test selective installation
   - Use configuration file
   - Run package validation

---

**Need more help?** Open an issue on [GitHub](https://github.com/jrock2004/dotfiles/issues) with:
- OS and version
- Error messages
- Steps you've tried
- Contents of `~/.dotfiles-install.log`

Happy migrating! 🚀
