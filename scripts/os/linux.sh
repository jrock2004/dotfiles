#!/bin/bash
# Linux-specific orchestration
# Handles all Linux installation logic including distro detection and WSL support
# Dependencies: All component files, package-manager.sh, wsl.sh

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/detect.sh"
source "$SCRIPT_DIR/lib/package-manager.sh"
source "$SCRIPT_DIR/os/wsl.sh"

# Source all component files
source "$SCRIPT_DIR/components/directories.sh"
source "$SCRIPT_DIR/components/shell.sh"
source "$SCRIPT_DIR/components/neovim.sh"
source "$SCRIPT_DIR/components/tmux.sh"
source "$SCRIPT_DIR/components/rust.sh"
source "$SCRIPT_DIR/components/volta.sh"
source "$SCRIPT_DIR/components/lua.sh"
source "$SCRIPT_DIR/components/claude.sh"
source "$SCRIPT_DIR/components/stow.sh"

###########################################
# LINUX ORCHESTRATION
###########################################

setup_linux() {
    log_info "Starting Linux installation"
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                    Dotfiles Installation for Linux                        ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"

    # Detect distribution
    local distro="${DISTRO:-unknown}"

    log_info "Detected distribution: $distro"
    if [ "${IS_WSL:-false}" = "true" ]; then
        log_info "WSL ${WSL_VERSION:-unknown} detected"
    fi

    # Install build tools first
    show_step "Installing build tools"
    case "$distro" in
        ubuntu|debian)
            if [ "$DRY_RUN" != true ]; then
                sudo apt-get update
                sudo apt-get install -y build-essential software-properties-common
            else
                echo "[DRY RUN] Would install build-essential on Ubuntu/Debian"
            fi
            ;;
        fedora|rhel)
            if [ "$DRY_RUN" != true ]; then
                sudo dnf groupinstall -y "Development Tools"
            else
                echo "[DRY RUN] Would install Development Tools on Fedora/RHEL"
            fi
            ;;
        arch)
            if [ "$DRY_RUN" != true ]; then
                sudo pacman -S --noconfirm base-devel
            else
                echo "[DRY RUN] Would install base-devel on Arch"
            fi
            ;;
    esac

    # Install common packages
    show_step "Installing common packages"
    pkg_install_from_file "$DOTFILES/packages/common.txt" "common packages"

    # Install Linux core packages
    if [ -f "$DOTFILES/packages/linux/core.txt" ]; then
        pkg_install_from_file "$DOTFILES/packages/linux/core.txt" "Linux core packages"
    fi

    # Install optional packages
    if [ -f "$DOTFILES/packages/optional.txt" ]; then
        log_info "Installing optional packages..."
        while IFS= read -r package; do
            [ -n "$package" ] && ! [[ "$package" =~ ^# ]] && pkg_install_optional "$package"
        done < "$DOTFILES/packages/optional.txt"
    fi

    # Setup directories
    if should_install_component "directories"; then
        show_step "Creating directories"
        setup_directories
    fi

    # Setup development tools
    show_step "Installing development tools"
    should_install_component "fzf" && setup_fzf
    should_install_component "neovim" && setup_neovim
    should_install_component "rust" && setup_rust

    # Setup shell
    if should_install_component "shell"; then
        show_step "Configuring shell (zsh + zap)"
        setup_shell
    fi

    # Setup tmux
    if should_install_component "tmux"; then
        show_step "Setting up tmux"
        setup_tmux
    fi

    # Setup Volta
    if should_install_component "volta"; then
        show_step "Setting up Node.js (Volta)"
        setup_volta
    fi

    # Stow dotfiles
    if should_install_component "stow"; then
        show_step "Symlinking dotfiles"
        setup_stow
    fi

    # WSL-specific setup
    if [ "${IS_WSL:-false}" = "true" ]; then
        show_step "Configuring WSL-specific features"

        # Install WSL-specific packages
        if [ -f "$DOTFILES/packages/wsl/wsl-specific.txt" ]; then
            pkg_install_from_file "$DOTFILES/packages/wsl/wsl-specific.txt" "WSL-specific packages"
        fi

        # Run WSL setup
        setup_wsl
    fi

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                    Installation completed successfully! 🎉                 ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"
    log_success "Linux installation completed!"
}

# Export setup function
export -f setup_linux
