#!/bin/bash
# Component: Claude
# Description: Install Claude Code CLI
# Dependencies: curl, bash

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# SETUP FUNCTION
###########################################

setup_claude() {
    printTopBorder
    log_info "Installing Claude Code CLI"
    printBottomBorder

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install Claude Code CLI"
        return 0
    fi

    if [ ! -d "$HOME/.claude" ] || [ "$FORCE_INSTALL" = true ]; then
        retry_command curl -fsSL https://claude.ai/install.sh | bash
        log_success "Claude Code CLI installed"
    else
        log_info "Claude Code CLI already installed, skipping"
    fi
}

# Export setup function
export -f setup_claude
