#!/bin/bash
# Dotfiles Installation Script v2.0.0
# Modular architecture with component-based installation

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

###########################################
# GLOBAL VARIABLES
###########################################

# Calculate DOTFILES based on script location (scripts/ is subdirectory of repo root)
# If DOTFILES is already set (e.g., from root install.sh), use that value
if [ -z "$DOTFILES" ]; then
    DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="2.0.0"
OS=""
USE_DESKTOP_ENV=FALSE
FORCE_INSTALL=false
DRY_RUN=false
NON_INTERACTIVE=false
SKIP_COMPONENTS=()
ONLY_COMPONENTS=()

###########################################
# LOAD CONFIGURATION
###########################################

# Load configuration from .dotfiles.env if exists
if [ -f "$HOME/.dotfiles.env" ]; then
    source "$HOME/.dotfiles.env"
    # Convert string-based SKIP_COMPONENTS/ONLY_COMPONENTS to arrays
    # If SKIP_COMPONENTS has a comma, it needs to be split into an array
    if [ "${#SKIP_COMPONENTS[@]}" -eq 1 ] && [[ "${SKIP_COMPONENTS[0]}" == *","* ]]; then
        IFS=',' read -ra SKIP_COMPONENTS <<< "${SKIP_COMPONENTS[0]}"
    fi
    if [ "${#ONLY_COMPONENTS[@]}" -eq 1 ] && [[ "${ONLY_COMPONENTS[0]}" == *","* ]]; then
        IFS=',' read -ra ONLY_COMPONENTS <<< "${ONLY_COMPONENTS[0]}"
    fi
    # Log message will appear after common.sh is sourced
fi

###########################################
# LOAD LIBRARIES (in correct order)
###########################################

# 1. Common utilities (base layer - no dependencies)
source "$SCRIPT_DIR/lib/common.sh"

# 2. UI libraries
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/gum-wrapper.sh"

# 3. Detection libraries
source "$SCRIPT_DIR/lib/detect.sh"

# 4. Package management (depends on detect.sh and common.sh)
source "$SCRIPT_DIR/lib/package-manager.sh"

# Log configuration file loading if it happened
if [ -f "$HOME/.dotfiles.env" ]; then
    log_info "Loaded configuration from ~/.dotfiles.env"
fi

###########################################
# CLI HELP AND VERSION
###########################################

show_help() {
    cat <<EOF
Dotfiles Installation Script v$VERSION

Usage: $0 [OPTIONS]

Options:
  -h, --help              Show this help message
  -v, --version           Show version information
  --dry-run               Preview actions without executing them
  --non-interactive       Use defaults, skip all prompts (for CI/automation)
  --force                 Force reinstall even if already installed
  --skip <component>      Skip specific component(s) (comma-separated)
  --only <component>      Install only specific component(s) (comma-separated)
  --list-components       List all available components

Available Components:
  - directories          Create standard directories
  - homebrew            Install Homebrew and packages
  - vscode              Install VS Code extensions
  - fonts               Install fonts
  - claude              Install Claude Code CLI
  - fzf                 Install FZF
  - lua                 Install Lua language server
  - neovim              Install Neovim dependencies
  - rust                Install Rust toolchain
  - shell               Configure zsh and zap
  - tmux                Install tmux plugin manager
  - volta               Install Volta and Node.js
  - stow                Symlink dotfiles
  - macos-defaults      Configure macOS defaults

Examples:
  $0                                  # Interactive installation
  $0 --non-interactive                # Automated installation
  $0 --skip lua,rust                  # Skip Lua and Rust
  $0 --only shell,neovim              # Install only shell and neovim
  $0 --dry-run                        # Preview what would be installed
  $0 --force                          # Force reinstall everything

EOF
}

show_version() {
    echo "Dotfiles Installation Script v$VERSION"
}

list_components() {
    echo "Available components:"
    echo "  - directories"
    echo "  - homebrew"
    echo "  - vscode"
    echo "  - fonts"
    echo "  - claude"
    echo "  - fzf"
    echo "  - lua"
    echo "  - neovim"
    echo "  - rust"
    echo "  - shell"
    echo "  - tmux"
    echo "  - volta"
    echo "  - stow"
    echo "  - macos-defaults"
}

###########################################
# ARGUMENT PARSING
###########################################

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            --dry-run)
                DRY_RUN=true
                log_info "Dry run mode enabled"
                shift
                ;;
            --non-interactive)
                NON_INTERACTIVE=true
                log_info "Non-interactive mode enabled"
                shift
                ;;
            --force)
                FORCE_INSTALL=true
                log_info "Force install mode enabled"
                shift
                ;;
            --skip)
                IFS=',' read -ra SKIP_COMPONENTS <<< "$2"
                log_info "Skipping components: ${SKIP_COMPONENTS[*]:-none}"
                shift 2
                ;;
            --only)
                IFS=',' read -ra ONLY_COMPONENTS <<< "$2"
                log_info "Installing only components: ${ONLY_COMPONENTS[*]:-none}"
                shift 2
                ;;
            --list-components)
                list_components
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

###########################################
# INTERACTIVE QUESTIONS
###########################################

initialQuestions() {
    # Show banner
    if command -v show_banner &> /dev/null; then
        show_banner
        echo ""
        show_header "Dotfiles Installation System" 75
    elif [ -f "$DOTFILES/docs/title.txt" ]; then
        cat "$DOTFILES/docs/title.txt"
    fi

    if [ "$NON_INTERACTIVE" = true ]; then
        log_info "Non-interactive mode: using defaults"
        # Auto-detect OS instead of assuming macOS
        local detected_os=$(detect_os)
        case "$detected_os" in
            macos)
                OS="mac"
                ;;
            linux)
                OS="linux"
                ;;
            *)
                log_error "Unsupported OS: $detected_os"
                exit 1
                ;;
        esac
        USE_DESKTOP_ENV=FALSE
        log_info "Detected OS: $OS"
        return
    fi

    # Welcome message
    if command -v section &> /dev/null; then
        section "Welcome to Dotfiles Setup"
        print_info "This installer will guide you through setting up your development environment"
    else
        printTopBorder
        echo "Going to ask some questions to make setting up your new machine easier"
        printBottomBorder
    fi
    echo ""

    # OS Selection
    if command -v print_step &> /dev/null; then
        print_step "Select your operating system"
    else
        echo "What OS are we setting up today?"
    fi
    echo ""

    local os_choice
    if command -v ui_choose &> /dev/null; then
        os_choice=$(ui_choose "Choose your OS:" "Mac OSX" "Linux" "Exit")
    else
        echo "1) Mac OSX"
        echo "2) Linux"
        echo "3) Exit"
        read -rp "Choose [1-3]: " choice_num
        case $choice_num in
            1) os_choice="Mac OSX" ;;
            2) os_choice="Linux" ;;
            *) os_choice="Exit" ;;
        esac
    fi

    case "$os_choice" in
        "Mac OSX")
            OS="mac"
            if command -v print_success &> /dev/null; then
                print_success "Selected: Mac OSX"
            fi
            ;;
        "Linux")
            OS="linux"
            if command -v print_success &> /dev/null; then
                print_success "Selected: Linux"
            fi
            ;;
        *)
            if command -v print_error &> /dev/null; then
                print_error "Installation cancelled"
            else
                echo "Installation cancelled"
            fi
            exit 1
            ;;
    esac

    echo ""

    # Desktop Environment Question
    if command -v print_step &> /dev/null; then
        print_step "Desktop environment configuration"
    else
        echo "Do you have a desktop environment?"
    fi
    echo ""

    if command -v ui_confirm &> /dev/null; then
        if ui_confirm "Do you have a desktop environment?" "No"; then
            USE_DESKTOP_ENV=TRUE
            print_success "Desktop environment: Yes"
        else
            USE_DESKTOP_ENV=FALSE
            print_info "Desktop environment: No"
        fi
    else
        read -rp "[y]es or [n]o (default: no) : " choice_desktop
        case $choice_desktop in
            y)
                USE_DESKTOP_ENV=TRUE
                ;;
            *)
                USE_DESKTOP_ENV=FALSE
                ;;
        esac
    fi

    echo ""

    # Show installation summary
    if [ ${#ONLY_COMPONENTS[@]:-0} -eq 0 ] && [ ${#SKIP_COMPONENTS[@]:-0} -eq 0 ]; then
        if command -v section &> /dev/null; then
            section "Installation Summary"
            print_info "OS: $OS"
            print_info "Desktop Environment: $USE_DESKTOP_ENV"
            print_info "Components: All (default)"
            echo ""

            if ! ui_confirm "Proceed with installation?" "Yes"; then
                print_warning "Installation cancelled"
                exit 0
            fi
        fi
    fi
}

###########################################
# MAIN EXECUTION
###########################################

# Parse command line arguments first
parse_args "$@"

# Ask initial questions
initialQuestions

# Detect OS and load appropriate orchestrator
case "$OS" in
    mac)
        source "$SCRIPT_DIR/os/macos.sh"
        setup_macos
        ;;
    linux)
        source "$SCRIPT_DIR/os/linux.sh"
        setup_linux
        ;;
    *)
        log_error "Unknown OS: $OS"
        echo "Something went wrong, try again and if it still fails, open an issue on Github"
        exit 1
        ;;
esac

log_success "Installation completed successfully!"
