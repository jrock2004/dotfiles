#!/bin/bash
# Component: Stow
# Description: Use GNU Stow to symlink dotfiles from files/ to $HOME
# Dependencies: stow

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# SETUP FUNCTION
###########################################

setup_stow() {
    log_info "Using stow to manage symlinking dotfiles"

    # Backup existing dotfiles before stowing
    backup_dotfiles

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would backup and remove existing config files"
        echo "[DRY RUN] Would run stow to symlink files/ to $HOME"
        return 0
    fi

    if [ "$CI" == true ]; then
        # Some things to do when running via CI
        rm -Rf ~/.gitconfig
    fi

    rm -Rf ~/.zshrc
    rm -Rf ~/.zprofile
    rm -Rf ~/.zshenv

    if [ "$(command -v brew)" ]; then
        rm -Rf ~/.zprofile

        "$(brew --prefix)"/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
        log_success "Dotfiles symlinked successfully"
    elif [ "$(command -v stow)" ]; then
        /usr/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
        log_success "Dotfiles symlinked successfully"
    else
        log_error "stow command not found. Please install GNU Stow first."
        return 1
    fi
}

# Export setup function
export -f setup_stow
