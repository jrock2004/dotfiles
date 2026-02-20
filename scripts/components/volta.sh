#!/bin/bash
# Component: Volta
# Description: Install Volta and Node.js, handle Rosetta on macOS
# Dependencies: curl, bash

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# SETUP FUNCTION
###########################################

setup_volta() {
    printTopBorder
    log_info "Going to use Volta for managing node versions"
    printBottomBorder

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install Volta and Node.js LTS"
        [ "$OS" = "mac" ] && echo "[DRY RUN] Would install Rosetta for macOS compatibility"
        return 0
    fi

    if [ ! -d "$HOME/.volta" ] || [ "$FORCE_INSTALL" = true ]; then
        retry_command curl https://get.volta.sh | bash -s -- --skip-setup

        # For now volta needs this for node and stuff to work
        if [ "$OS" = "mac" ]; then
            softwareupdate --install-rosetta
        fi

        "$HOME"/.volta/bin/volta install node@lts yarn@1.22.19 pnpm
        log_success "Volta installed successfully"
    else
        log_info "Volta already installed, skipping"
    fi
}

# Export setup function
export -f setup_volta
