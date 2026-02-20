#!/bin/bash
# Component: Rust
# Description: Install Rust toolchain via rustup
# Dependencies: curl, bash

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# SETUP FUNCTION
###########################################

setup_rust() {
    printTopBorder
    log_info "Setting up rust"
    printBottomBorder

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install Rust via rustup"
        return 0
    fi

    if [ ! -d "$HOME/.cargo" ] || [ "$FORCE_INSTALL" = true ]; then
        retry_command curl https://sh.rustup.rs -sSf | sh -s -- -y

        # Source cargo environment for current session
        if [ -f "$HOME/.cargo/env" ]; then
            source "$HOME/.cargo/env"
        fi
        log_success "Rust installed successfully"
    else
        log_info "Rust already installed, skipping"
    fi
}

# Export setup function
export -f setup_rust
