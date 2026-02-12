#!/bin/bash
# Dotfiles Update Script v2.0.0
# Updates dotfiles from git and re-applies configurations

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

###########################################
# GLOBAL VARIABLES
###########################################

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="2.0.0"
DRY_RUN=false
UPDATE_PACKAGES=true
BACKUP_DIR="$HOME/.dotfiles.backup.update.$(date +%Y%m%d_%H%M%S)"
RESTART_SERVICES=true

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
Dotfiles Update Script v$VERSION

Usage: $0 [OPTIONS]

Options:
  -h, --help              Show this help message
  -v, --version           Show version information
  --dry-run               Preview actions without executing them
  --no-packages           Skip package updates
  --no-restart            Skip restarting services
  --backup-dir <path>     Custom backup directory (default: ~/.dotfiles.backup.update.<timestamp>)

Examples:
  $0                      # Update everything
  $0 --dry-run            # Preview what will be updated
  $0 --no-packages        # Update dotfiles but skip package updates
  $0 --no-restart         # Update but don't restart services

This script will:
  1. Backup current dotfiles
  2. Pull latest changes from git
  3. Show what changed
  4. Re-apply symlinks with stow
  5. Update packages (if enabled)
  6. Restart services (if enabled)

EOF
    exit 0
}

show_version() {
    echo "Dotfiles Update Script v$VERSION"
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
        --no-packages)
            UPDATE_PACKAGES=false
            shift
            ;;
        --no-restart)
            RESTART_SERVICES=false
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
# UPDATE FUNCTIONS
###########################################

# Check if we're in a git repository
check_git_repo() {
    if [ ! -d "$DOTFILES/.git" ]; then
        log_error "Not a git repository: $DOTFILES"
        log_info "This script only works with git-managed dotfiles"
        exit 1
    fi
}

# Show current status
show_git_status() {
    log_info "Current git status:"
    cd "$DOTFILES"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would show git status"
        return 0
    fi

    git status --short
    echo ""

    # Check if there are uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        log_warning "You have uncommitted changes in your dotfiles"
        if ! ui_confirm "Continue with update anyway?" "Yes"; then
            log_info "Update cancelled by user"
            exit 0
        fi
    fi
}

# Fetch latest changes
fetch_updates() {
    log_info "Fetching latest changes from remote..."

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: git fetch origin"
        return 0
    fi

    cd "$DOTFILES"
    git fetch origin

    # Check if we're behind
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    local behind_count
    behind_count=$(git rev-list --count HEAD..origin/"$current_branch" 2>/dev/null || echo "0")

    if [ "$behind_count" -gt 0 ]; then
        log_info "Your dotfiles are $behind_count commits behind origin/$current_branch"
        return 0
    else
        log_success "Your dotfiles are up to date!"
        if ! ui_confirm "No updates available. Re-apply configurations anyway?" "No"; then
            log_info "Update cancelled by user"
            exit 0
        fi
    fi
}

# Show what changed
show_changes() {
    log_info "Changes in this update:"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would show git diff"
        return 0
    fi

    cd "$DOTFILES"
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Show commits that will be pulled
    echo ""
    echo "Commits to be applied:"
    git log --oneline --decorate HEAD..origin/"$current_branch" 2>/dev/null || echo "No new commits"
    echo ""

    # Show file changes
    echo "Files that will change:"
    git diff --stat HEAD..origin/"$current_branch" 2>/dev/null || echo "No changes"
    echo ""
}

# Pull latest changes
pull_updates() {
    log_info "Pulling latest changes..."

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: git pull origin"
        return 0
    fi

    cd "$DOTFILES"
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    git pull origin "$current_branch"
    log_success "Dotfiles updated successfully"
}

# Backup current dotfiles
backup_before_update() {
    log_info "Creating backup before update at $BACKUP_DIR"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would backup dotfiles to $BACKUP_DIR"
        return 0
    fi

    mkdir -p "$BACKUP_DIR"

    # Backup key files
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

# Re-apply stow
reapply_stow() {
    log_info "Re-applying symlinks with stow..."

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would run: stow --ignore '.DS_Store' -v -R -t ~ -d $DOTFILES files"
        return 0
    fi

    cd "$DOTFILES"

    if command -v brew >/dev/null 2>&1; then
        "$(brew --prefix)"/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
        log_success "Symlinks updated successfully"
    elif command -v stow >/dev/null 2>&1; then
        stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
        log_success "Symlinks updated successfully"
    else
        log_error "stow command not found. Please install GNU Stow."
        return 1
    fi
}

# Update packages
update_packages() {
    if [ "$UPDATE_PACKAGES" = false ]; then
        log_info "Skipping package updates (--no-packages flag)"
        return 0
    fi

    log_info "Updating packages..."

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would update packages"
        return 0
    fi

    detect_os

    case "$DETECTED_OS" in
        macos)
            if command -v brew >/dev/null 2>&1; then
                log_info "Updating Homebrew packages..."
                brew update
                brew upgrade
                log_success "Homebrew packages updated"
            fi
            ;;
        linux)
            case "$DISTRO" in
                ubuntu|debian)
                    if command -v apt >/dev/null 2>&1; then
                        log_info "Updating APT packages..."
                        sudo apt update
                        sudo apt upgrade -y
                        log_success "APT packages updated"
                    fi
                    ;;
                fedora|rhel)
                    if command -v dnf >/dev/null 2>&1; then
                        log_info "Updating DNF packages..."
                        sudo dnf update -y
                        log_success "DNF packages updated"
                    fi
                    ;;
                arch)
                    if command -v pacman >/dev/null 2>&1; then
                        log_info "Updating Pacman packages..."
                        sudo pacman -Syu --noconfirm
                        log_success "Pacman packages updated"
                    fi
                    ;;
            esac
            ;;
        wsl)
            log_info "Updating WSL packages..."
            case "$DISTRO" in
                ubuntu|debian)
                    sudo apt update && sudo apt upgrade -y
                    ;;
                fedora|rhel)
                    sudo dnf update -y
                    ;;
            esac
            log_success "WSL packages updated"
            ;;
    esac

    # Update Node.js via Volta
    if command -v volta >/dev/null 2>&1; then
        log_info "Updating Node.js via Volta..."
        volta install node@lts
        log_success "Node.js updated"
    fi

    # Update Neovim plugins
    if command -v nvim >/dev/null 2>&1; then
        log_info "Updating Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
        log_success "Neovim plugins updated"
    fi
}

# Restart services
restart_services() {
    if [ "$RESTART_SERVICES" = false ]; then
        log_info "Skipping service restart (--no-restart flag)"
        return 0
    fi

    log_info "Restarting services..."

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would restart services (tmux, yabai, skhd, sketchybar)"
        return 0
    fi

    detect_os

    case "$DETECTED_OS" in
        macos)
            # Restart yabai, skhd, sketchybar if running
            if pgrep -x "yabai" > /dev/null; then
                log_info "Restarting yabai..."
                brew services restart yabai
            fi

            if pgrep -x "skhd" > /dev/null; then
                log_info "Restarting skhd..."
                brew services restart skhd
            fi

            if pgrep -x "sketchybar" > /dev/null; then
                log_info "Restarting sketchybar..."
                brew services restart sketchybar
            fi
            ;;
    esac

    # Reload tmux config if tmux is running
    if [ -n "${TMUX:-}" ] || pgrep -x "tmux" > /dev/null; then
        log_info "Reloading tmux configuration..."
        tmux source-file ~/.tmux.conf 2>/dev/null || true
    fi

    log_success "Services restarted"
}

# Show summary
show_summary() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║                    Dotfiles Update Summary                        ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""

    if [ "$DRY_RUN" = true ]; then
        echo "🔍 DRY RUN MODE: No changes will be made"
        echo ""
    fi

    echo "Actions to be performed:"
    echo "  ✓ Backup current dotfiles"
    echo "  ✓ Pull latest changes from git"
    echo "  ✓ Re-apply symlinks with stow"

    if [ "$UPDATE_PACKAGES" = true ]; then
        echo "  ✓ Update packages"
    else
        echo "  ⊗ Skip package updates"
    fi

    if [ "$RESTART_SERVICES" = true ]; then
        echo "  ✓ Restart services"
    else
        echo "  ⊗ Skip service restart"
    fi

    echo ""
}

###########################################
# MAIN UPDATE PROCESS
###########################################

main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║              Dotfiles Update Script v$VERSION                     ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""

    # Check if in git repo
    check_git_repo

    # Show current status
    show_git_status

    # Fetch updates
    fetch_updates

    # Show what will change
    show_changes

    # Show summary
    show_summary

    if [ "$DRY_RUN" = false ]; then
        if ! ui_confirm "Proceed with update?" "Yes"; then
            log_info "Update cancelled by user"
            exit 0
        fi
    fi

    # Backup before updating
    backup_before_update

    # Pull updates
    pull_updates

    # Re-apply stow
    reapply_stow

    # Update packages
    update_packages

    # Restart services
    restart_services

    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║                      Update Complete                              ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""

    if [ "$DRY_RUN" = false ]; then
        log_success "Dotfiles updated successfully!"
        log_info "Backup saved to: $BACKUP_DIR"
        echo ""
        echo "Next steps:"
        echo "  1. Restart your terminal or run: exec zsh"
        echo "  2. Verify configurations are working correctly"
        echo "  3. Report any issues at: https://github.com/jrock2004/dotfiles/issues"
    else
        log_info "Dry run completed. No changes were made."
    fi
}

# Run main function
main
