# Dotfiles Installation Improvement Tasks

> **Status Legend**: ⬜ Not Started | 🟨 In Progress | ✅ Complete | ❌ Blocked

---

## Phase 1: Fix Critical Bugs (Priority: HIGH)
**Estimated Time**: 1-2 hours

- [ ] ⬜ **Fix hardcoded username** (install.sh:216)
  - Change `/Users/jcostanzo/.zprofile` to `$HOME/.zprofile`

- [ ] ⬜ **Fix undefined `info` function** (install.sh:144, 150)
  - Replace `info` calls with `echo` or define the function

- [ ] ⬜ **Update Lua Language Server repository**
  - Change from `sumneko/lua-language-server` to `LuaLS/lua-language-server`

- [ ] ⬜ **Make setupTmux idempotent**
  - Check if `~/.tmux/plugins/tpm` exists before cloning

- [ ] ⬜ **Make setupLua idempotent**
  - Check if `~/lua-language-server` exists before cloning

- [ ] ⬜ **Make setupRust non-interactive**
  - Add `-y` flag to rustup install command
  - Source cargo env after installation

- [ ] ⬜ **Add zap plugin manager installation**
  - Install zap in setupShell (currently missing but required by .zshrc)
  - Use: `zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1`
  - Make it idempotent (check if already installed)

---

## Phase 2: Improve Reliability (Priority: HIGH)
**Estimated Time**: 3-5 hours

- [ ] ⬜ **Add error handling**
  - Add `set -euo pipefail` to all scripts
  - Create error handling functions
  - Add trap for cleanup on error

- [ ] ⬜ **Add logging system**
  - Create `log()`, `log_error()`, `log_success()` functions
  - Add timestamps to log messages
  - Optional: log to file for debugging

- [ ] ⬜ **Add retry logic for network operations**
  - Create `retry_command()` function
  - Apply to curl, git clone operations
  - Add exponential backoff

- [ ] ⬜ **Add progress tracking**
  - Implement step counter (e.g., "Step 3/10")
  - Show what's being installed/configured

- [ ] ⬜ **Make all setup functions idempotent**
  - Check if tool already installed before installing
  - Skip if already configured
  - Add `--force` flag to override

- [ ] ⬜ **Backup existing dotfiles before stowing**
  - Create backup directory `~/.dotfiles.backup.<timestamp>`
  - Backup any existing files that would be overwritten
  - Add restore functionality if installation fails

- [ ] ⬜ **Add CLI flags support**
  - Add `--help` flag with usage information
  - Add `--version` flag
  - Add `--list-components` to show available components
  - Add `--dry-run` to preview actions without executing
  - Add `--non-interactive` for CI/automation (use defaults)
  - Add `--force` to override idempotency checks
  - Add `--skip <component>` to exclude specific components
  - Add `--only <component>` to install only specific components

---

## Phase 3: Package Management System (Priority: HIGH)
**Estimated Time**: 4-6 hours

- [ ] ⬜ **Create package directory structure**
  ```
  packages/
  ├── common.txt              # Cross-platform essentials
  ├── optional.txt            # Nice-to-have tools
  ├── macos/
  │   ├── core.txt           # macOS packages
  │   ├── gui-apps.txt       # macOS GUI apps (casks)
  │   ├── fonts.txt          # Nerd fonts
  │   └── macos-only.txt     # macOS-specific (yabai, skhd, etc.)
  ├── linux/
  │   ├── core.txt           # Linux packages
  │   ├── gui-apps.txt       # Linux GUI apps
  │   └── linux-only.txt     # Linux-specific (i3, rofi, etc.)
  ├── windows/
  │   ├── core.txt           # Windows packages
  │   ├── gui-apps.txt       # Windows apps
  │   └── windows-only.txt   # Windows-specific (PowerToys, etc.)
  ├── wsl/
  │   └── wsl-specific.txt   # WSL additions
  └── mappings/
      ├── common-to-macos.map
      ├── common-to-ubuntu.map
      ├── common-to-arch.map
      ├── common-to-fedora.map
      └── common-to-windows.map
  ```

- [ ] ⬜ **Populate package files from current Brewfile**
  - Extract common tools to `common.txt`
  - Extract GUI apps to `macos/gui-apps.txt`
  - Extract fonts to `macos/fonts.txt`
  - Extract macOS-only to `macos/macos-only.txt`

- [ ] ⬜ **Create mapping files for package name differences**
  - `common-to-ubuntu.map` (e.g., fd=fd-find)
  - `common-to-arch.map` (e.g., gh=github-cli)
  - Other distro mappings

- [ ] ⬜ **Build package sync validator script**
  - Create `scripts/validate-packages.sh`
  - Check that common.txt packages have mappings
  - Report missing packages per OS
  - Show diff between platforms
  - Verify no duplicate packages across files

- [ ] ⬜ **Handle optional packages gracefully**
  - If optional.txt package unavailable, warn but continue
  - Log which optional packages were skipped
  - Don't fail installation for optional packages

- [ ] ⬜ **Create package manager abstraction layer**
  - Implement `pkg_install()` function that reads from package files
  - Implement `pkg_update()` function
  - Support brew, apt, pacman, dnf, winget
  - Handle package name lookups via mapping files
  - Return exit codes for success/failure/skipped

- [ ] ⬜ **Brewfile migration strategy**
  - Keep Brewfile temporarily during transition
  - Add deprecation notice to Brewfile
  - Create `scripts/migrate-brewfile.sh` to convert to new format
  - Test both systems work in parallel
  - Plan removal date for Brewfile

- [ ] ⬜ **Update documentation for new package system**
  - Document how to add new packages
  - Document OS-specific vs common packages
  - Add examples of when to use each file
  - Document the mapping system
  - Document migration from Brewfile

---

## Phase 4: UI/UX Improvements (Priority: MEDIUM)
**Estimated Time**: 3-4 hours

- [ ] ⬜ **Install gum as optional dependency**
  - Add gum to `packages/optional.txt`
  - Check if gum is available before using it
  - Gracefully fallback if not installed

- [ ] ⬜ **Create UI library (lib/ui.sh)**
  - Implement color constants (RED, GREEN, YELLOW, etc.)
  - Implement symbols (✓, ✗, →, ℹ, ⚠)
  - Create `show_header()` function with ASCII art
  - Create `show_progress()` progress bar function
  - Create `spinner()` function for background tasks
  - Create `box()` function for styled output

- [ ] ⬜ **Implement gum integration with fallbacks**
  - Create `ui_choose()` wrapper:
    - First choice: gum choose (if available)
    - Fallback: fzf (already have this)
    - Last resort: bash select menu
  - Create `ui_spin()` wrapper (gum spin or custom spinner)
  - Create `ui_confirm()` wrapper (gum confirm or read -p)
  - Create `ui_input()` wrapper (gum input or read -p)
  - Create `ui_multi_select()` for component selection (gum choose --no-limit or fzf --multi)

- [ ] ⬜ **Replace interactive prompts**
  - Use `ui_choose()` for OS selection
  - Use `ui_multi_select()` for component selection
  - Add component descriptions in selection UI
  - Add confirmation before installation starts
  - Skip all prompts if `--non-interactive` flag is set

---

## Phase 5: Linux Support (Priority: HIGH)
**Estimated Time**: 6-10 hours

- [ ] ⬜ **Create OS detection system**
  - Create `lib/detect.sh`
  - Detect macOS (Intel vs ARM)
  - Detect Linux distro (Ubuntu, Debian, Fedora, Arch)
  - Detect architecture (x86_64, arm64, aarch64)
  - Export OS variables (OS, DISTRO, ARCH, BREW_PREFIX)

- [ ] ⬜ **Update curl-install.sh for cross-platform**
  - Remove macOS-specific xcode-select check
  - Detect OS before cloning
  - Install git if not present (per OS)
  - Call correct setup based on detected OS

- [ ] ⬜ **Create Linux-specific setup script**
  - Create `os/linux.sh`
  - Implement `setup_linux_prerequisites()`
  - Install build-essential (Ubuntu) / base-devel (Arch) / Development Tools (Fedora)
  - Handle distro-specific package managers

- [ ] ⬜ **Populate Linux package files**
  - Create initial `packages/linux/core.txt`
  - Research package names for Ubuntu/Debian/Fedora/Arch
  - Create mapping files for common packages
  - Document any packages not available on Linux

- [ ] ⬜ **Implement distro-specific package installation**
  - Ubuntu/Debian: apt-get (add PPAs for newer packages like neovim)
  - Fedora/RHEL: dnf
  - Arch: pacman (and yay for AUR if needed)
  - Handle sudo requirements appropriately

- [ ] ⬜ **Handle GUI apps on Linux**
  - Strategy: Try native package first, then Flatpak, then Snap
  - Detect if Flatpak/Snap available
  - Create `packages/linux/gui-apps-flatpak.txt` and `gui-apps-snap.txt`
  - Some apps may not be available (macOS-specific like Ghostty)

- [ ] ⬜ **Handle fonts on Linux**
  - Download Nerd Fonts from GitHub releases
  - Install to `~/.local/share/fonts`
  - Run `fc-cache -fv` to refresh font cache
  - Create `scripts/install-fonts-linux.sh`

- [ ] ⬜ **Port macOS-specific functions to Linux**
  - setupShell: handle /etc/shells on Linux (may need sudo)
  - setupFzf: install via package manager
  - setupStow: ensure Linux compatibility (should already work)
  - setupVolta: test on Linux x86_64 and ARM

- [ ] ⬜ **Handle Powerlevel10k vs Starship**
  - Decision: Use Starship on Linux (already cross-platform)
  - Keep Powerlevel10k on macOS (optional)
  - Update .zshrc to detect OS and load appropriate theme
  - Add Starship config to files/.config/

- [ ] ⬜ **Test Volta on Linux**
  - Test if Volta works on Linux ARM and x86_64
  - If issues, add support for nvm or fnm as alternative
  - Make Node.js version manager configurable

- [ ] ⬜ **Create conditional config stowing**
  - Detect OS before stowing
  - Skip macOS-only configs (yabai, skhd, sketchybar) on Linux
  - Skip Linux-only configs (i3, rofi, etc.) on macOS
  - Create platform-specific stow targets

---

## Phase 6: WSL Support (Priority: MEDIUM)
**Estimated Time**: 2-4 hours

- [ ] ⬜ **Implement WSL detection**
  - Check for `/proc/version` containing "microsoft"
  - Detect WSL1 vs WSL2
  - Detect underlying distro

- [ ] ⬜ **Create WSL-specific setup script**
  - Create `os/wsl.sh`
  - Enable systemd on WSL2
  - Configure Windows interop
  - Fix clock drift issues

- [ ] ⬜ **Handle WSL-specific paths**
  - Windows drives mounted at `/mnt/c`, etc.
  - Set BROWSER to Windows browser
  - Handle clipboard integration

- [ ] ⬜ **Conditional features for WSL**
  - Skip display manager configs
  - Skip audio configs
  - Optional: integrate with Windows Terminal

---

## Phase 7: Code Restructuring (Priority: MEDIUM)
**Estimated Time**: 4-6 hours

- [ ] ⬜ **Restructure scripts directory**
  ```
  scripts/
  ├── install.sh              # Main entry point (updated)
  ├── uninstall.sh            # Uninstall script
  ├── lib/
  │   ├── common.sh          # Shared utilities
  │   ├── detect.sh          # OS/distro detection
  │   ├── package-manager.sh # Package abstraction
  │   └── ui.sh              # UI functions
  ├── os/
  │   ├── macos.sh           # macOS-specific
  │   ├── linux.sh           # Linux-specific
  │   └── wsl.sh             # WSL-specific
  └── components/
      ├── shell.sh           # Shell setup (zsh, zap)
      ├── neovim.sh          # Neovim setup
      ├── tmux.sh            # Tmux setup
      ├── rust.sh            # Rust setup
      ├── volta.sh           # Volta/Node setup
      └── lua.sh             # Lua setup
  ```

- [ ] ⬜ **Extract component setup functions**
  - Move setupShell to `components/shell.sh`
  - Move setupNeovim to `components/neovim.sh`
  - Move setupTmux to `components/tmux.sh`
  - Move setupRust to `components/rust.sh`
  - Move setupVolta to `components/volta.sh`
  - Move setupLua to `components/lua.sh`
  - Move setupFzf to `components/shell.sh` (part of shell setup)
  - Move setupClaudeCli to `components/claude.sh`

- [ ] ⬜ **Define component dependencies**
  - Create dependency map:
    - neovim → git, curl
    - tmux → git (for tpm)
    - volta → curl
    - shell → git, curl, stow
  - Auto-install dependencies or warn if missing
  - Resolve dependency order automatically

- [ ] ⬜ **Update main install.sh**
  - Parse CLI arguments (--help, --dry-run, --non-interactive, etc.)
  - Source all lib files in correct order
  - Detect OS and source appropriate os/script
  - Load component files
  - Orchestrate installation based on user selection
  - Handle errors gracefully

- [ ] ⬜ **Add configuration file support**
  - Create `.dotfiles.env.example` with all options
  - Support environment variables:
    - `SKIP_COMPONENTS="rust,lua"` - skip specific components
    - `DOTFILES_BACKUP_DIR` - custom backup location
    - `PACKAGE_MANAGER` - force specific package manager
    - `NON_INTERACTIVE=true` - skip prompts
  - Load from `~/.dotfiles.env` if exists
  - Document all available options

---

## Phase 8: Additional Features (Priority: LOW)
**Estimated Time**: 2-4 hours

- [ ] ⬜ **Add dry-run mode**
  - Implement `--dry-run` flag
  - Show what would be installed without doing it
  - Useful for testing

- [ ] ⬜ **Add uninstall script**
  - Create `scripts/uninstall.sh`
  - Remove symlinks via stow
  - Optional: remove installed packages
  - Backup important configs before removal

- [ ] ⬜ **Add update script**
  - Pull latest changes from git
  - Re-run stow for new configs
  - Update installed packages
  - Restart services if needed

- [ ] ⬜ **Add rollback on failure**
  - Backup existing configs before install
  - Create `cleanup_on_error()` function
  - Restore backups if installation fails
  - Add trap for automatic rollback

---

## Phase 9: Testing & CI (Priority: MEDIUM)
**Estimated Time**: 2-4 hours

- [ ] ⬜ **Create Docker test environments**
  - Create `test/Dockerfile.ubuntu`
  - Create `test/Dockerfile.fedora`
  - Create `test/Dockerfile.arch`
  - Add test script to run in containers

- [ ] ⬜ **Set up GitHub Actions**
  - Create `.github/workflows/test-install.yml`
  - Test on macos-latest
  - Test on ubuntu-latest
  - Test with `--dry-run` and `--non-interactive`

- [ ] ⬜ **Add shellcheck integration**
  - Run shellcheck on all scripts
  - Fix any warnings
  - Add to CI pipeline

- [ ] ⬜ **Create integration tests**
  - Test that dotfiles are properly symlinked
  - Test that required binaries are installed
  - Test that shell is changed to zsh
  - Verify neovim can start without errors

---

## Phase 10: Documentation (Priority: HIGH)
**Estimated Time**: 3-4 hours

- [ ] ⬜ **Update CLAUDE.md (CRITICAL)**
  - Document new directory structure (packages/, scripts/lib/, scripts/components/)
  - Update installation commands (new flags: --dry-run, --non-interactive, etc.)
  - Document new package system (common.txt, OS-specific files, mappings)
  - Update architecture section (package abstraction, UI library, OS detection)
  - Add cross-platform commands for each OS
  - Document component dependencies
  - Add new common tasks (validate packages, migrate from Brewfile, etc.)
  - Add troubleshooting per OS (macOS, Linux distros, WSL)
  - Update key dependencies to reflect new package structure
  - Add migration notes from old to new system

- [ ] ⬜ **Update README.md**
  - Add platform support matrix (macOS, Ubuntu, Fedora, Arch, WSL)
  - Update installation command examples for each platform
  - Add prerequisite requirements per OS
  - Document new CLI flags
  - Add troubleshooting section
  - Add screenshots of new UI (if implemented)
  - Update quick start guide

- [ ] ⬜ **Create CONTRIBUTING.md**
  - Document how to add new packages (to common.txt, OS-specific files)
  - Document how to create mapping files
  - Document how to add new components
  - Document testing process (Docker, CI)
  - Add code style guidelines for shell scripts
  - Document how to run validator script

- [ ] ⬜ **Create MIGRATION.md**
  - Guide for users upgrading from old install system
  - Explain Brewfile → packages/ transition
  - List breaking changes
  - Provide rollback instructions if needed

- [ ] ⬜ **Create platform-specific docs**
  - Create `docs/MACOS.md` (macOS-specific features, yabai, skhd, etc.)
  - Create `docs/LINUX.md` (Linux-specific features, distro differences)
  - Create `docs/WSL.md` (WSL-specific setup, Windows interop)
  - Document platform-specific quirks and workarounds

---

## Optional Future Enhancements

- [ ] ⬜ Add Windows native support (PowerShell script)
- [ ] ⬜ Add Nix package manager support
- [ ] ⬜ Add Flatpak/Snap support for GUI apps on Linux
- [ ] ⬜ Create web-based installer generator
- [ ] ⬜ Add telemetry/analytics (opt-in) for installation success rates
- [ ] ⬜ Add auto-update mechanism for dotfiles
- [ ] ⬜ Create dotfiles sync service for multiple machines

---

## Notes

### Package Management Approach

**Why separate files instead of complex mapping?**
- Cleaner and more maintainable
- Acknowledges that different platforms have different apps (yabai on macOS, i3 on Linux)
- Easier to see what's installed on each platform
- Simple mapping files only for packages with different names
- Validator script ensures consistency for common tools

**Structure Benefits:**
- `common.txt` = tools that SHOULD exist everywhere (git, neovim, fzf, etc.)
- `optional.txt` = nice-to-have tools (may skip on some platforms)
- OS-specific folders = embrace platform differences
- Mapping files = only for name differences (fd vs fd-find)
- Validator = ensures common tools are available on all platforms

### General Notes

- **Keep backward compatibility during refactoring**
  - Keep old install.sh as install-legacy.sh during transition
  - Use feature flags to toggle between old/new behavior
  - Maintain Brewfile alongside new package system temporarily

- **Testing strategy**
  - Create git branches for each phase
  - Test on macOS (Intel and ARM if possible)
  - Test on Linux VM before proceeding
  - Use `--dry-run` flag extensively

- **VS Code extensions**
  - Keep `scripts/vscode-extensions.txt` separate
  - Not part of package system (different installation mechanism)
  - Consider moving to `config/vscode/extensions.txt` for consistency

- **Document breaking changes**
  - Create CHANGELOG.md for migration notes
  - Add migration guide for users updating from old version

- **Get feedback from users testing on different platforms**
  - Test Ubuntu, Fedora, Arch if possible
  - Test WSL1 and WSL2
  - Document platform-specific quirks

---

**Total Estimated Time**: 32-52 hours
**Priority Order**: Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6 → Phase 7 → Phase 9 → Phase 10 → Phase 8

**Rationale for order:**
- Phase 1-2: Fix bugs and add reliability (foundation)
- Phase 3: Package system (needed before Linux support)
- Phase 4: UI improvements (better UX during development)
- Phase 5: Linux support (uses package system)
- Phase 6: WSL support (builds on Linux support)
- Phase 7: Restructure (consolidate all changes)
- Phase 9: Testing (validate everything works)
- Phase 10: Documentation (CRITICAL - update CLAUDE.md for future Claude Code sessions)
- Phase 8: Additional features (nice-to-haves)

**Note:** Phase 10 is especially important as CLAUDE.md ensures future Claude Code instances can work effectively with the new architecture.
