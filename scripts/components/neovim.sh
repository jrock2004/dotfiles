#!/bin/bash
# Component: Neovim
# Description: Install Neovim Python dependencies (pynvim)
# Dependencies: python, pip

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# SETUP FUNCTION
###########################################

setup_neovim() {
    log_info "Setting up neovim dependencies"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install pynvim via pip"
        return 0
    fi

    if [ "$(command -v python)" ]; then
        python -m pip install --upgrade pynvim
        log_success "Neovim dependencies installed"
    else
        log_warning "Python not found, skipping neovim python dependencies"
    fi
}

# Export setup function
export -f setup_neovim
