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
        echo "[DRY RUN] Would check Neovim version and upgrade if needed"
        return 0
    fi

    # Check if we need to upgrade Neovim on Linux (LazyVim requires >= 0.11.2)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v nvim &> /dev/null; then
            local nvim_version
            nvim_version=$(nvim --version | head -n1 | grep -oP 'v\K[0-9]+\.[0-9]+' || echo "0.0")
            local major minor
            major=$(echo "$nvim_version" | cut -d. -f1)
            minor=$(echo "$nvim_version" | cut -d. -f2)

            # Check if version is less than 0.11
            if [ "$major" -eq 0 ] && [ "$minor" -lt 11 ]; then
                log_warning "Neovim $nvim_version is too old for LazyVim (requires >= 0.11.2)"
                log_info "Installing latest Neovim from unstable PPA..."

                # Add Neovim unstable PPA and upgrade
                if command -v add-apt-repository &> /dev/null; then
                    sudo add-apt-repository -y ppa:neovim-ppa/unstable
                    sudo apt-get update
                    sudo apt-get install -y --only-upgrade neovim
                    log_success "Neovim upgraded to $(nvim --version | head -n1)"
                else
                    log_warning "Cannot upgrade Neovim automatically - add-apt-repository not found"
                fi
            fi
        fi
    fi

    # Install Python dependencies
    if [ "$(command -v python)" ]; then
        python -m pip install --upgrade pynvim
        log_success "Neovim dependencies installed"
    else
        log_warning "Python not found, skipping neovim python dependencies"
    fi
}

# Export setup function
export -f setup_neovim
