#!/bin/bash
# Component: Tmux
# Description: Install tmux plugin manager (tpm)
# Dependencies: git, curl

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# SETUP FUNCTION
###########################################

setup_tmux() {
    printTopBorder
    log_info "Setting up tmux plugin manager"
    printBottomBorder

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would clone tmux plugin manager to ~/.tmux/plugins/tpm"
        return 0
    fi

    if [ ! -d ~/.tmux/plugins/tpm ] || [ "$FORCE_INSTALL" = true ]; then
        retry_command git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        log_success "Tmux plugin manager installed"
    else
        log_info "tmux plugin manager already installed, skipping"
    fi
}

# Export setup function
export -f setup_tmux
