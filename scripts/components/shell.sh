#!/bin/bash
# Component: Shell
# Description: Shell configuration (zsh + zap plugin manager + FZF)
# Dependencies: zsh, curl, brew (optional)

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# FZF SETUP
###########################################

setup_fzf() {
    printTopBorder
    log_info "Setting up FZF"
    printBottomBorder

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install FZF key bindings and completions"
        return 0
    fi

    if [ -x "$(command -v brew)" ]; then
        "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
        log_success "FZF setup completed"
    else
        log_warning "Homebrew not found, skipping FZF setup"
    fi
}

###########################################
# SHELL SETUP
###########################################

setup_shell() {
    printTopBorder
    log_info "Switching SHELL to zsh"
    printBottomBorder

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would switch default shell to zsh"
        echo "[DRY RUN] Would install zap plugin manager"
        return 0
    fi

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"

    if ! grep "$zsh_path" /etc/shells; then
        log_info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    # Skip changing default shell in non-interactive mode (CI/automation)
    # chsh requires password authentication which fails in CI
    if [[ "$SHELL" != "$zsh_path" ]]; then
        if [ "$NON_INTERACTIVE" = true ]; then
            log_info "Non-interactive mode: skipping default shell change (use 'chsh -s $zsh_path' manually)"
        else
            chsh -s "$zsh_path"
            log_success "default shell changed to $zsh_path"
        fi
    fi

    # Install zap plugin manager if not already installed
    if [ ! -d "$HOME/.local/share/zap" ] || [ "$FORCE_INSTALL" = true ]; then
        log_info "Installing zap plugin manager"
        retry_command zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
        log_success "zap plugin manager installed"
    else
        log_info "zap plugin manager already installed, skipping"
    fi
}

# Export setup functions
export -f setup_fzf
export -f setup_shell
