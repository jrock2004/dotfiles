#!/bin/bash
# Component: Directories
# Description: Creates standard directory structure
# Dependencies: None

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# SETUP FUNCTION
###########################################

setup_directories() {
    log_info "Creating directories"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would create: $HOME/Development"
        echo "[DRY RUN] Would create: $HOME/.tmux/plugins"
        return 0
    fi

    mkdir -p "$HOME/Development"
    mkdir -p "$HOME/.tmux/plugins"

    # if [ "$USE_DESKTOP_ENV" = FALSE ]; then
    #     mkdir -p "$HOME/Pictures"
    #     mkdir -p "$HOME/Pictures/avatars"
    #     mkdir -p "$HOME/Pictures/wallpapers"
    # fi

    log_success "Directories created"
}

# Export setup function
export -f setup_directories
