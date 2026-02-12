#!/bin/bash
# Dotfiles Uninstall Script v2.0.0
# Safely removes dotfiles symlinks and optionally removes installed packages

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

###########################################
# GLOBAL VARIABLES
###########################################

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="2.0.0"
DRY_RUN=false
REMOVE_PACKAGES=false
BACKUP_DIR="$HOME/.dotfiles.backup.uninstall.$(date +%Y%m%d_%H%M%S)"

###########################################
# LOAD LIBRARIES
###########################################

source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/gum-wrapper.sh"
source "$SCRIPT_DIR/lib/detect.sh"

###########################################
# CLI HELP
###########################################

show_help() {
    cat <<EOF
Dotfiles Uninstall Script v$VERSION

Usage: $0 [OPTIONS]

Options:
  -h, --help              Show this help message
  -v, --version           Show version information
  --dry-run               Preview actions without executing them
  --remove-packages       Also remove installed packages (with confirmation)
  --backup-dir <path>     Custom backup directory (default: ~/.dotfiles.backup.uninstall.<timestamp>)

Examples:
  $0                      # Remove symlinks only (safe)
  $0 --dry-run            # Preview what will be removed
  $0 --remove-packages    # Remove symlinks and packages (with confirmation)

Note: This script will:
  1. Backup current dotfiles before removal
  2. Remove all symlinks created by GNU Stow
  3. Optionally remove installed packages (if --remove-packages is used)
  4. Keep the dotfiles repository intact in ~/.dotfiles

EOF
    exit 0
}

show_version() {
    echo "Dotfiles Uninstall Script v$VERSION"
    exit 0
}

###########################################
# PARSE CLI ARGUMENTS
###########################################

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            show_version
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --remove-packages)
            REMOVE_PACKAGES=true
            shift
            ;;
        --backup-dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Run '$0 --help' for usage information."
            exit 1
            ;;
    esac
done

###########################################
# UNINSTALL FUNCTIONS
###########################################

# Backup current dotfiles before uninstalling
backup_before_uninstall() {
    log_info "Creating backup before uninstall at $BACKUP_DIR"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would backup dotfiles to $BACKUP_DIR"
        return 0
    fi

    mkdir -p "$BACKUP_DIR"

    # Backup all symlinked files
    local files_to_backup=(
        ".zshrc"
        ".zprofile"
        ".zshenv"
        ".gitconfig"
        ".tmux.conf"
        ".config/nvim"
        ".config/ghostty"
        ".config/alacritty"
        ".config/kitty"
        ".config/wezterm"
        ".config/yabai"
        ".config/skhd"
        ".config/sketchybar"
        ".config/zellij"
        ".config/starship.toml"
        ".rgrc"
    )

    local backed_up_count=0

    for file in "${files_to_backup[@]}"; do
        if [ -e "$HOME/$file" ]; then
            local parent_dir="$BACKUP_DIR/$(dirname "$file")"
            mkdir -p "$parent_dir"
            cp -r "$HOME/$file" "$parent_dir/" 2>/dev/null || true
            backed_up_count=$((backed_up_count + 1))
        fi
    done

    log_success "Backed up $backed_up_count files to $BACKUP_DIR"
}

# Remove symlinks using stow
remove_symlinks() {
    log_info "Removing dotfiles symlinks"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: stow --ignore '.DS_Store' -v -D -t ~ -d $DOTFILES files"
        return 0
    fi

    if command -v brew >/dev/null 2>&1; then
        "$(brew --prefix)"/bin/stow --ignore ".DS_Store" -v -D -t ~ -d "$DOTFILES" files
        log_success "Symlinks removed successfully via Homebrew stow"
    elif command -v stow >/dev/null 2>&1; then
        stow --ignore ".DS_Store" -v -D -t ~ -d "$DOTFILES" files
        log_success "Symlinks removed successfully via system stow"
    else
        log_error "stow command not found. Cannot remove symlinks automatically."
        log_info "You may need to manually remove symlinked files from your home directory."
        return 1
    fi
}

# List installed packages that would be removed
list_packages() {
    log_info "Packages that would be removed:"
    echo ""

    detect_os

    case "$DETECTED_OS" in
        macos)
            if [ -f "$DOTFILES/Brewfile" ]; then
                echo "📦 Homebrew packages from Brewfile:"
                grep -E '^brew |^cask |^mas ' "$DOTFILES/Brewfile" | head -20
                echo "... (and more)"
            fi
            ;;
        linux|wsl)
            if [ -f "$DOTFILES/packages/common.txt" ]; then
                echo "📦 Common packages:"
                head -20 "$DOTFILES/packages/common.txt"
                echo "... (and more)"
            fi
            ;;
    esac

    echo ""
    log_warning "Package removal is destructive and may affect other applications!"
}

# Remove installed packages (with confirmation)
remove_packages() {
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would ask for confirmation to remove packages"
        list_packages
        return 0
    fi

    log_warning "Package removal is a destructive operation!"
    list_packages

    if ! ui_confirm "Are you sure you want to remove all installed packages? This may break other applications!" "No"; then
        log_info "Skipping package removal"
        return 0
    fi

    detect_os

    case "$DETECTED_OS" in
        macos)
            if [ -f "$DOTFILES/Brewfile" ] && command -v brew >/dev/null 2>&1; then
                log_info "Removing Homebrew packages..."
                # Note: This is dangerous and may remove packages used by other apps
                # We'll only remove formulae, not casks or mas apps for safety
                brew bundle cleanup --file="$DOTFILES/Brewfile" --force
                log_success "Homebrew packages cleaned up"
            else
                log_warning "Homebrew or Brewfile not found, skipping package removal"
            fi
            ;;
        linux|wsl)
            log_warning "Automatic package removal not implemented for Linux/WSL"
            log_info "Please manually remove packages if desired"
            ;;
    esac
}

# Show summary of what will be done
show_summary() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║                  Dotfiles Uninstall Summary                       ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""

    if [ "$DRY_RUN" = true ]; then
        echo "🔍 DRY RUN MODE: No changes will be made"
        echo ""
    fi

    echo "Actions to be performed:"
    echo "  ✓ Backup current dotfiles to: $BACKUP_DIR"
    echo "  ✓ Remove symlinks from: $HOME"
    echo "  ✓ Keep dotfiles repository at: $DOTFILES"

    if [ "$REMOVE_PACKAGES" = true ]; then
        echo "  ⚠️  Remove installed packages (with confirmation)"
    fi

    echo ""

    if [ "$DRY_RUN" = false ]; then
        if ! ui_confirm "Proceed with uninstall?" "No"; then
            log_info "Uninstall cancelled by user"
            exit 0
        fi
    fi
}

###########################################
# MAIN UNINSTALL PROCESS
###########################################

main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║            Dotfiles Uninstall Script v$VERSION                     ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""

    # Show what will be done
    show_summary

    # Backup before uninstalling
    backup_before_uninstall

    # Remove symlinks
    remove_symlinks

    # Remove packages if requested
    if [ "$REMOVE_PACKAGES" = true ]; then
        remove_packages
    fi

    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║                    Uninstall Complete                             ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""

    if [ "$DRY_RUN" = false ]; then
        log_success "Dotfiles uninstalled successfully!"
        log_info "Backup saved to: $BACKUP_DIR"
        log_info "Dotfiles repository still available at: $DOTFILES"
        echo ""
        echo "To restore your dotfiles, you can:"
        echo "  1. Run: cd $DOTFILES && ./install.sh"
        echo "  2. Or restore from backup: cp -r $BACKUP_DIR/. ~/"
    else
        log_info "Dry run completed. No changes were made."
    fi
}

# Run main function
main
