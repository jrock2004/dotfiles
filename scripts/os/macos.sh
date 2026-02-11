#!/bin/bash
# macOS-specific orchestration
# Handles all macOS installation logic including Homebrew, packages, and components
# Dependencies: All component files, package-manager.sh

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/package-manager.sh"

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
# MACOS ORCHESTRATION
###########################################

setup_macos() {
    log_info "Starting macOS installation"
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                    Dotfiles Installation for macOS                        ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"

    if should_install_component "homebrew"; then
        show_step "Installing Homebrew and packages"
        if [ -z "$(command -v brew)" ]; then
            if [ "$DRY_RUN" = true ]; then
                echo "[DRY RUN] Would install Homebrew"
            else
                sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
                echo "eval '$(/opt/homebrew/bin/brew shellenv)'" >>"$HOME/.zprofile"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        fi

        # Install packages using new package management system
        log_info "Installing packages from new package system..."

        # Install Homebrew taps first
        if [ -f "$DOTFILES/packages/macos/taps.txt" ]; then
            while IFS= read -r tap; do
                [ -n "$tap" ] && ! [[ "$tap" =~ ^# ]] && pkg_tap "$tap"
            done < "$DOTFILES/packages/macos/taps.txt"
        fi

        # Install common packages
        pkg_install_from_file "$DOTFILES/packages/common.txt" "common packages"

        # Install macOS core packages
        pkg_install_from_file "$DOTFILES/packages/macos/core.txt" "macOS core packages"

        # Install macOS-only packages (yabai, skhd, sketchybar, etc.)
        pkg_install_from_file "$DOTFILES/packages/macos/macos-only.txt" "macOS-only packages"

        # Install optional packages (don't fail if they don't exist)
        if [ -f "$DOTFILES/packages/optional.txt" ]; then
            log_info "Installing optional packages..."
            while IFS= read -r package; do
                [ -n "$package" ] && ! [[ "$package" =~ ^# ]] && pkg_install_optional "$package"
            done < "$DOTFILES/packages/optional.txt"
        fi

        # Install GUI apps
        if [ -f "$DOTFILES/packages/macos/gui-apps.txt" ]; then
            log_info "Installing GUI applications..."
            while IFS= read -r app; do
                [ -n "$app" ] && ! [[ "$app" =~ ^# ]] && pkg_install_cask "$app"
            done < "$DOTFILES/packages/macos/gui-apps.txt"
        fi

        # Install fonts
        if [ -f "$DOTFILES/packages/macos/fonts.txt" ]; then
            log_info "Installing fonts..."
            while IFS= read -r font; do
                [ -n "$font" ] && ! [[ "$font" =~ ^# ]] && pkg_install_cask "$font"
            done < "$DOTFILES/packages/macos/fonts.txt"
        fi

        log_success "All packages installed successfully"
    fi

    if should_install_component "vscode"; then
        show_step "Installing VS Code extensions"
        if [ -x "$(command -v code)" ] && [ -f ./scripts/vscode-extensions.txt ]; then
            if [ "$DRY_RUN" = true ]; then
                echo "[DRY RUN] Would install VS Code extensions from ./scripts/vscode-extensions.txt"
            else
                xargs -L1 code --install-extension < ./scripts/vscode-extensions.txt
            fi
            log_success "VS Code extensions installed"
        else
            log_warning "Code is not in path or extensions file not found"
        fi
    fi

    if should_install_component "fonts"; then
        show_step "Installing fonts"
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would download sketchybar-app-font.ttf to $HOME/Library/Fonts/"
        else
            retry_command curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.16/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
        fi
        log_success "Fonts installed"
    fi

    if should_install_component "directories"; then
        show_step "Creating directories"
        setup_directories
    fi

    show_step "Installing development tools"
    should_install_component "claude" && setup_claude
    should_install_component "fzf" && setup_fzf
    should_install_component "lua" && setup_lua
    should_install_component "neovim" && setup_neovim
    should_install_component "rust" && setup_rust

    if should_install_component "shell"; then
        show_step "Configuring shell (zsh + zap)"
        setup_shell
    fi

    if should_install_component "tmux"; then
        show_step "Setting up tmux"
        setup_tmux
    fi

    if should_install_component "volta"; then
        show_step "Setting up Node.js (Volta)"
        setup_volta
    fi

    if should_install_component "stow"; then
        show_step "Symlinking dotfiles"
        setup_stow
    fi

    if should_install_component "macos-defaults"; then
        show_step "Configuring macOS defaults"
        if [ "$DRY_RUN" = true ]; then
            echo "[DRY RUN] Would configure macOS defaults (key repeat, etc.)"
        else
            # disables the hold key menu to allow key repeat
            defaults write -g ApplePressAndHoldEnabled -bool false

            # The speed of repetition of characters
            defaults write -g KeyRepeat -int 2

            # Delay until repeat
            defaults write -g InitialKeyRepeat -int 15
        fi
        log_success "macOS defaults configured"
    fi

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                    Installation completed successfully! 🎉                 ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"
    log_success "Dotfiles installation completed"
}

# Export setup function
export -f setup_macos
