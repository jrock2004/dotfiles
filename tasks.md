# Dotfiles Installation Improvement Tasks

> **Status Legend**: ⬜ Not Started | 🟨 In Progress | ✅ Complete | ❌ Blocked

## Progress Overview

- ✅ **Phase 1**: Fix Critical Bugs - COMPLETE
- ✅ **Phase 2**: Improve Reliability - COMPLETE
- ✅ **Phase 3**: Package Management System - COMPLETE
- ✅ **Phase 4**: UI/UX Improvements - COMPLETE
- ✅ **Phase 5**: Linux Support - COMPLETE
- ✅ **Phase 6**: WSL Support - COMPLETE
- ✅ **Phase 7**: Code Restructuring - COMPLETE
- ⬜ **Phase 8**: Additional Features - Not Started
- ⬜ **Phase 9**: Testing & CI - Not Started
- ⬜ **Phase 10**: Documentation - Not Started (CRITICAL - must update CLAUDE.md)

**Completion Rate**: 7/10 phases complete (70%)

---

## Phase 1: Fix Critical Bugs (Priority: HIGH)
**Estimated Time**: 1-2 hours

- [x] ✅ **Fix hardcoded username** (install.sh:216)
  - Change `/Users/jcostanzo/.zprofile` to `$HOME/.zprofile`

- [x] ✅ **Fix undefined `info` function** (install.sh:144, 150)
  - Replace `info` calls with `echo` or define the function

- [x] ✅ **Update Lua Language Server repository**
  - Change from `sumneko/lua-language-server` to `LuaLS/lua-language-server`

- [x] ✅ **Make setupTmux idempotent**
  - Check if `~/.tmux/plugins/tpm` exists before cloning

- [x] ✅ **Make setupLua idempotent**
  - Check if `~/lua-language-server` exists before cloning

- [x] ✅ **Make setupRust non-interactive**
  - Add `-y` flag to rustup install command
  - Source cargo env after installation

- [x] ✅ **Add zap plugin manager installation**
  - Install zap in setupShell (currently missing but required by .zshrc)
  - Use: `zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1`
  - Make it idempotent (check if already installed)

---

## Phase 2: Improve Reliability (Priority: HIGH)
**Estimated Time**: 3-5 hours

- [x] ✅ **Add error handling**
  - Add `set -euo pipefail` to all scripts
  - Create error handling functions
  - Add trap for cleanup on error

- [x] ✅ **Add logging system**
  - Create `log()`, `log_error()`, `log_success()` functions
  - Add timestamps to log messages
  - Optional: log to file for debugging

- [x] ✅ **Add retry logic for network operations**
  - Create `retry_command()` function
  - Apply to curl, git clone operations
  - Add exponential backoff

- [x] ✅ **Add progress tracking**
  - Implement step counter (e.g., "Step 3/10")
  - Show what's being installed/configured

- [x] ✅ **Make all setup functions idempotent**
  - Check if tool already installed before installing
  - Skip if already configured
  - Add `--force` flag to override

- [x] ✅ **Backup existing dotfiles before stowing**
  - Create backup directory `~/.dotfiles.backup.<timestamp>`
  - Backup any existing files that would be overwritten
  - Add restore functionality if installation fails

- [x] ✅ **Add CLI flags support**
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

- [x] ✅ **Create package directory structure**
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

- [x] ✅ **Populate package files from current Brewfile**
  - Extract common tools to `common.txt`
  - Extract GUI apps to `macos/gui-apps.txt`
  - Extract fonts to `macos/fonts.txt`
  - Extract macOS-only to `macos/macos-only.txt`

- [x] ✅ **Create mapping files for package name differences**
  - `common-to-ubuntu.map` (e.g., fd=fd-find)
  - `common-to-arch.map` (e.g., gh=github-cli)
  - Other distro mappings

- [x] ✅ **Build package sync validator script**
  - Create `scripts/validate-packages.sh`
  - Check that common.txt packages have mappings
  - Report missing packages per OS
  - Show diff between platforms
  - Verify no duplicate packages across files

- [x] ✅ **Handle optional packages gracefully**
  - If optional.txt package unavailable, warn but continue
  - Log which optional packages were skipped
  - Don't fail installation for optional packages

- [x] ✅ **Create package manager abstraction layer**
  - Implement `pkg_install()` function that reads from package files
  - Implement `pkg_update()` function
  - Support brew, apt, pacman, dnf, winget
  - Handle package name lookups via mapping files
  - Return exit codes for success/failure/skipped

- [x] ✅ **Brewfile migration strategy**
  - Keep Brewfile temporarily during transition
  - Add deprecation notice to Brewfile
  - Create `scripts/migrate-brewfile.sh` to convert to new format
  - Test both systems work in parallel
  - Plan removal date for Brewfile

- [x] ✅ **Update documentation for new package system**
  - Document how to add new packages
  - Document OS-specific vs common packages
  - Add examples of when to use each file
  - Document the mapping system
  - Document migration from Brewfile

---

## Phase 4: UI/UX Improvements (Priority: MEDIUM)
**Estimated Time**: 3-4 hours

- [x] ✅ **Install gum as optional dependency**
  - Add gum to `packages/optional.txt`
  - Check if gum is available before using it
  - Gracefully fallback if not installed

- [x] ✅ **Create UI library (lib/ui.sh)**
  - Implement color constants (RED, GREEN, YELLOW, etc.)
  - Implement symbols (✓, ✗, →, ℹ, ⚠)
  - Create `show_header()` function with ASCII art
  - Create `show_progress()` progress bar function
  - Create `spinner()` function for background tasks
  - Create `box()` function for styled output

- [x] ✅ **Implement gum integration with fallbacks**
  - Create `ui_choose()` wrapper:
    - First choice: gum choose (if available)
    - Fallback: fzf (already have this)
    - Last resort: bash select menu
  - Create `ui_spin()` wrapper (gum spin or custom spinner)
  - Create `ui_confirm()` wrapper (gum confirm or read -p)
  - Create `ui_input()` wrapper (gum input or read -p)
  - Create `ui_multi_select()` for component selection (gum choose --no-limit or fzf --multi)

- [x] ✅ **Replace interactive prompts**
  - Use `ui_choose()` for OS selection
  - Use `ui_multi_select()` for component selection
  - Add component descriptions in selection UI
  - Add confirmation before installation starts
  - Skip all prompts if `--non-interactive` flag is set

---

## Phase 5: Linux Support (Priority: HIGH)
**Estimated Time**: 6-10 hours

- [x] ✅ **Create OS detection system**
  - Create `lib/detect.sh`
  - Detect macOS (Intel vs ARM)
  - Detect Linux distro (Ubuntu, Debian, Fedora, Arch)
  - Detect architecture (x86_64, arm64, aarch64)
  - Export OS variables (OS, DISTRO, ARCH, BREW_PREFIX)

- [x] ✅ **Update curl-install.sh for cross-platform**
  - Remove macOS-specific xcode-select check
  - Detect OS before cloning
  - Install git if not present (per OS)
  - Call correct setup based on detected OS

- [x] ✅ **Create Linux-specific setup script**
  - Create `os/linux.sh`
  - Implement `setup_linux_prerequisites()`
  - Install build-essential (Ubuntu) / base-devel (Arch) / Development Tools (Fedora)
  - Handle distro-specific package managers

- [x] ✅ **Populate Linux package files**
  - Create initial `packages/linux/core.txt`
  - Research package names for Ubuntu/Debian/Fedora/Arch
  - Create mapping files for common packages
  - Document any packages not available on Linux

- [x] ✅ **Implement distro-specific package installation**
  - Ubuntu/Debian: apt-get (add PPAs for newer packages like neovim)
  - Fedora/RHEL: dnf
  - Arch: pacman (and yay for AUR if needed)
  - Handle sudo requirements appropriately

- [x] ✅ **Handle GUI apps on Linux**
  - Strategy: Try native package first, then Flatpak, then Snap
  - Detect if Flatpak/Snap available
  - Create `packages/linux/gui-apps-flatpak.txt` and `gui-apps-snap.txt`
  - Some apps may not be available (macOS-specific like Ghostty)

- [x] ✅ **Handle fonts on Linux**
  - Download Nerd Fonts from GitHub releases
  - Install to `~/.local/share/fonts`
  - Run `fc-cache -fv` to refresh font cache
  - Create `scripts/install-fonts-linux.sh`

- [x] ✅ **Port macOS-specific functions to Linux**
  - setupShell: handle /etc/shells on Linux (may need sudo)
  - setupFzf: install via package manager
  - setupStow: ensure Linux compatibility (should already work)
  - setupVolta: test on Linux x86_64 and ARM

- [x] ✅ **Handle Powerlevel10k vs Starship**
  - Decision: Use Starship on Linux (already cross-platform)
  - Keep Powerlevel10k on macOS (optional)
  - Update .zshrc to detect OS and load appropriate theme
  - Add Starship config to files/.config/

- [x] ✅ **Test Volta on Linux**
  - Test if Volta works on Linux ARM and x86_64
  - If issues, add support for nvm or fnm as alternative
  - Make Node.js version manager configurable

- [x] ✅ **Create conditional config stowing**
  - Detect OS before stowing
  - Skip macOS-only configs (yabai, skhd, sketchybar) on Linux
  - Skip Linux-only configs (i3, rofi, etc.) on macOS
  - Create platform-specific stow targets

---

## Phase 6: WSL Support (Priority: MEDIUM)
**Estimated Time**: 2-4 hours

- [x] ✅ **Implement WSL detection**
  - Check for `/proc/version` containing "microsoft"
  - Detect WSL1 vs WSL2
  - Detect underlying distro

- [x] ✅ **Create WSL-specific setup script**
  - Create `os/wsl.sh`
  - Enable systemd on WSL2
  - Configure Windows interop
  - Fix clock drift issues

- [x] ✅ **Handle WSL-specific paths**
  - Windows drives mounted at `/mnt/c`, etc.
  - Set BROWSER to Windows browser
  - Handle clipboard integration

- [x] ✅ **Conditional features for WSL**
  - Skip display manager configs
  - Skip audio configs
  - Optional: integrate with Windows Terminal

---

## Phase 7: Code Restructuring (Priority: MEDIUM) ✅ COMPLETE
**Estimated Time**: 4-6 hours
**Actual Time**: ~6 hours

- [x] ✅ **Restructure scripts directory**
  ```
  scripts/
  ├── install.sh              # Main entry point (339 lines, down from 1159)
  ├── lib/
  │   ├── common.sh          # Shared utilities (logging, backup, retry, error handling)
  │   ├── detect.sh          # OS/distro detection
  │   ├── package-manager.sh # Package abstraction layer
  │   ├── ui.sh              # UI functions (colors, symbols)
  │   └── gum-wrapper.sh     # Interactive prompts with fallbacks
  ├── os/
  │   ├── macos.sh           # macOS-specific orchestration
  │   ├── linux.sh           # Linux-specific orchestration
  │   └── wsl.sh             # WSL-specific setup
  └── components/
      ├── directories.sh     # Directory creation
      ├── shell.sh           # Shell setup (zsh, zap, FZF)
      ├── neovim.sh          # Neovim dependencies (pynvim)
      ├── tmux.sh            # Tmux plugin manager (tpm)
      ├── rust.sh            # Rust toolchain (rustup)
      ├── volta.sh           # Volta/Node setup
      ├── lua.sh             # Lua language server
      ├── claude.sh          # Claude Code CLI
      └── stow.sh            # GNU Stow symlinking
  ```

- [x] ✅ **Extract component setup functions**
  - Extracted setupShell + setupFzf to `components/shell.sh`
  - Extracted setupNeovim to `components/neovim.sh`
  - Extracted setupTmux to `components/tmux.sh`
  - Extracted setupRust to `components/rust.sh`
  - Extracted setupVolta to `components/volta.sh`
  - Extracted setupLua to `components/lua.sh`
  - Extracted setupClaudeCli to `components/claude.sh`
  - Extracted setupDirectories to `components/directories.sh`
  - Extracted setupStow to `components/stow.sh`

- [x] ✅ **Define component dependencies**
  - Documented dependencies in component file headers
  - Component dependency map created:
    - directories → none
    - shell → git, curl, zsh, brew (optional)
    - neovim → python, pip
    - tmux → git, curl
    - rust → curl, bash
    - volta → curl, bash
    - lua → git, curl, luarocks (optional)
    - claude → curl, bash
    - stow → stow
  - Proper library loading order established (common → ui → gum-wrapper → detect → package-manager)

- [x] ✅ **Update main install.sh**
  - Reduced from 1159 lines to 339 lines (71% reduction)
  - Parse CLI arguments (--help, --version, --list-components, --dry-run, --non-interactive, --force, --skip, --only)
  - Source all lib files in correct order
  - Detect OS and source appropriate os/ orchestration script
  - Load component files via OS orchestrators
  - Orchestrate installation based on user selection
  - All error handling preserved (trap, cleanup, error_handler)
  - Backward compatibility via wrapper install.sh in root

- [x] ✅ **Add configuration file support**
  - Created `.dotfiles.env.example` with all options
  - Support environment variables:
    - `SKIP_COMPONENTS="rust,lua"` - skip specific components ✅
    - `ONLY_COMPONENTS="shell,neovim"` - install only specific components ✅
    - `BACKUP_DIR` - custom backup location ✅
    - `PACKAGE_MANAGER` - force specific package manager ✅
    - `NON_INTERACTIVE=true` - skip prompts ✅
    - `DRY_RUN=true` - preview without execution ✅
    - `FORCE_INSTALL=true` - force reinstall ✅
    - `LOG_FILE` - custom log file path ✅
    - `USE_DESKTOP_ENV` - desktop environment flag ✅
    - `OS` - override OS detection ✅
  - Load from `~/.dotfiles.env` if exists ✅
  - Array conversion for comma-separated values ✅
  - All options documented in .dotfiles.env.example ✅

**Key Achievements:**
- ✅ 71% reduction in main install.sh (1159 → 339 lines)
- ✅ 9 self-contained component files
- ✅ OS-specific orchestration (macOS/Linux/WSL)
- ✅ Reusable utility libraries
- ✅ Configuration file support (.dotfiles.env)
- ✅ No circular dependencies
- ✅ Backward compatibility (install-legacy.sh backup)
- ✅ All CLI flags working and tested
- ✅ Dry-run mode fully functional
- ✅ Component skipping/selection working

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
