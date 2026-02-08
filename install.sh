#!/bin/bash

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

###########################################
# VARIABLES
###########################################

DOTFILES="$HOME/.dotfiles"
OS=""
USE_DESKTOP_ENV=FALSE
FORCE_INSTALL=false
CURRENT_STEP=0
TOTAL_STEPS=10
BACKUP_DIR="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
NON_INTERACTIVE=false
SKIP_COMPONENTS=()
ONLY_COMPONENTS=()
VERSION="1.0.0"

###########################################
# LOAD UI LIBRARIES
###########################################

# Source UI library for colors and styled output
if [ -f "$DOTFILES/lib/ui.sh" ]; then
    source "$DOTFILES/lib/ui.sh"
fi

# Source gum wrapper for interactive prompts
if [ -f "$DOTFILES/lib/gum-wrapper.sh" ]; then
    source "$DOTFILES/lib/gum-wrapper.sh"
fi

###########################################
# ERROR HANDLING
###########################################

# Error handler function
error_handler() {
    local line_number=$1
    local exit_code=$2
    echo "❌ Error occurred in script at line $line_number with exit code $exit_code"
    echo "Installation failed. Please check the error above and try again."
    exit "$exit_code"
}

# Cleanup function called on error
cleanup_on_error() {
    echo "Performing cleanup..."

    # Restore from backup if it exists
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A $BACKUP_DIR)" ]; then
        log_warning "Restoring backup from $BACKUP_DIR"
        cp -r "$BACKUP_DIR"/. "$HOME/"
        log_info "Backup restored"
    fi
}

# Set up trap to catch errors
trap 'cleanup_on_error; error_handler ${LINENO} $?' ERR

###########################################
# HELPER FUNCTIONS
###########################################

lowercase() {
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

printBottomBorder() {
    echo "---------------------------------------------------------------------------"
}

printTopBorder() {
    printf "\n---------------------------------------------------------------------------\n"
}

###########################################
# LOGGING FUNCTIONS
###########################################

# Log file location (optional)
LOG_FILE="${DOTFILES}/.install.log"

# Log with timestamp
log() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

# Log success message
log_success() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ✅ $message" | tee -a "$LOG_FILE"
}

# Log error message
log_error() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ❌ $message" | tee -a "$LOG_FILE" >&2
}

# Log warning message
log_warning() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ⚠️  $message" | tee -a "$LOG_FILE"
}

# Log info message
log_info() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ℹ️  $message" | tee -a "$LOG_FILE"
}

# Show step progress
show_step() {
    local step_name="$1"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Step $CURRENT_STEP/$TOTAL_STEPS: $step_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "Step $CURRENT_STEP/$TOTAL_STEPS: $step_name"
}

###########################################
# BACKUP FUNCTIONS
###########################################

# Backup existing dotfiles
backup_dotfiles() {
    log_info "Backing up existing dotfiles to $BACKUP_DIR"

    mkdir -p "$BACKUP_DIR"

    # List of common dotfiles to backup
    local files_to_backup=(
        ".zshrc"
        ".zprofile"
        ".zshenv"
        ".gitconfig"
        ".tmux.conf"
        ".config/nvim"
        ".config/ghostty"
        ".config/alacritty"
        ".config/kitty"
        ".config/wezterm"
        ".config/yabai"
        ".config/skhd"
        ".config/sketchybar"
    )

    local backed_up_count=0

    for file in "${files_to_backup[@]}"; do
        if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            # File exists and is not a symlink (so it's not already managed by stow)
            local parent_dir="$BACKUP_DIR/$(dirname "$file")"
            mkdir -p "$parent_dir"
            cp -r "$HOME/$file" "$parent_dir/"
            backed_up_count=$((backed_up_count + 1))
            log_info "Backed up: $file"
        fi
    done

    if [ $backed_up_count -gt 0 ]; then
        log_success "Backed up $backed_up_count files/directories to $BACKUP_DIR"
    else
        log_info "No files needed backup (all were symlinks or didn't exist)"
    fi
}

###########################################
# PACKAGE MANAGEMENT ABSTRACTION
###########################################

# Detect operating system and package manager
detect_package_manager() {
    if command -v brew &> /dev/null; then
        echo "brew"
    elif command -v apt-get &> /dev/null; then
        echo "apt"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v yum &> /dev/null; then
        echo "yum"
    else
        echo "unknown"
    fi
}

# Get platform for package mapping
get_platform() {
    local pkg_manager=$(detect_package_manager)

    case "$pkg_manager" in
        brew)
            echo "macos"
            ;;
        apt)
            echo "ubuntu"
            ;;
        pacman)
            echo "arch"
            ;;
        dnf|yum)
            echo "fedora"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Read packages from file (ignore comments and empty lines)
read_package_file() {
    local file=$1
    if [ -f "$file" ]; then
        grep -v '^#' "$file" | grep -v '^$' | sed 's/[[:space:]]*$//'
    fi
}

# Get mapped package name for current platform
get_mapped_package_name() {
    local package=$1
    local platform=$(get_platform)
    local mapping_file="$DOTFILES/packages/mappings/common-to-${platform}.map"

    # If mapping file exists and has a mapping for this package, use it
    if [ -f "$mapping_file" ]; then
        local mapped=$(grep "^${package}=" "$mapping_file" 2>/dev/null | cut -d'=' -f2)
        if [ -n "$mapped" ]; then
            echo "$mapped"
            return 0
        fi
    fi

    # Otherwise return the original package name
    echo "$package"
}

# Install a single package using the appropriate package manager
pkg_install_single() {
    local package=$1
    local pkg_manager=$(detect_package_manager)
    local mapped_package=$(get_mapped_package_name "$package")

    log_info "Installing: $package $([ "$mapped_package" != "$package" ] && echo "($mapped_package)")"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install: $mapped_package via $pkg_manager"
        return 0
    fi

    case "$pkg_manager" in
        brew)
            brew install "$mapped_package" || log_warning "Failed to install $mapped_package"
            ;;
        apt)
            sudo apt-get install -y "$mapped_package" || log_warning "Failed to install $mapped_package"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$mapped_package" || log_warning "Failed to install $mapped_package"
            ;;
        dnf)
            sudo dnf install -y "$mapped_package" || log_warning "Failed to install $mapped_package"
            ;;
        yum)
            sudo yum install -y "$mapped_package" || log_warning "Failed to install $mapped_package"
            ;;
        *)
            log_error "Unknown package manager. Cannot install $package"
            return 1
            ;;
    esac
}

# Install packages from a package file
pkg_install_from_file() {
    local package_file=$1
    local description=${2:-"packages"}

    if [ ! -f "$package_file" ]; then
        log_warning "Package file not found: $package_file"
        return 1
    fi

    log_info "Installing $description from $(basename $package_file)..."

    local packages=$(read_package_file "$package_file")
    local count=0
    local failed=0

    while IFS= read -r package; do
        if [ -n "$package" ]; then
            if pkg_install_single "$package"; then
                ((count++))
            else
                ((failed++))
            fi
        fi
    done <<< "$packages"

    if [ $failed -eq 0 ]; then
        log_success "Installed $count $description successfully"
    else
        log_warning "Installed $count $description ($failed failed)"
    fi
}

# Install optional packages (don't fail if they don't exist)
pkg_install_optional() {
    local package=$1
    local pkg_manager=$(detect_package_manager)
    local mapped_package=$(get_mapped_package_name "$package")

    log_info "Installing optional: $package"

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install optional: $mapped_package via $pkg_manager"
        return 0
    fi

    case "$pkg_manager" in
        brew)
            brew install "$mapped_package" 2>/dev/null || log_info "Skipped unavailable package: $package"
            ;;
        apt)
            sudo apt-get install -y "$mapped_package" 2>/dev/null || log_info "Skipped unavailable package: $package"
            ;;
        pacman)
            sudo pacman -S --noconfirm "$mapped_package" 2>/dev/null || log_info "Skipped unavailable package: $package"
            ;;
        dnf)
            sudo dnf install -y "$mapped_package" 2>/dev/null || log_info "Skipped unavailable package: $package"
            ;;
        yum)
            sudo yum install -y "$mapped_package" 2>/dev/null || log_info "Skipped unavailable package: $package"
            ;;
        *)
            log_info "Skipped unavailable package: $package"
            ;;
    esac
}

# Install Homebrew taps
pkg_tap() {
    local tap=$1

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would tap: $tap"
        return 0
    fi

    if command -v brew &> /dev/null; then
        log_info "Tapping: $tap"
        brew tap "$tap" || log_warning "Failed to tap $tap"
    fi
}

# Install Homebrew cask
pkg_install_cask() {
    local cask=$1

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would install cask: $cask"
        return 0
    fi

    if command -v brew &> /dev/null; then
        log_info "Installing cask: $cask"
        brew install --cask "$cask" || log_warning "Failed to install cask $cask"
    fi
}

###########################################
# RETRY LOGIC
###########################################

# Retry command with exponential backoff
retry_command() {
    local max_attempts=3
    local timeout=1
    local attempt=1
    local exit_code=0

    while [ $attempt -le $max_attempts ]; do
        if "$@"; then
            return 0
        else
            exit_code=$?
        fi

        if [ $attempt -lt $max_attempts ]; then
            log_warning "Command failed (attempt $attempt/$max_attempts). Retrying in ${timeout}s..."
            sleep $timeout
            timeout=$((timeout * 2))  # Exponential backoff
        fi

        attempt=$((attempt + 1))
    done

    log_error "Command failed after $max_attempts attempts"
    return $exit_code
}

###########################################
# CLI FLAGS AND HELP
###########################################

show_help() {
    cat <<EOF
Dotfiles Installation Script

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

# Parse command line arguments
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

# Check if component should be installed
should_install_component() {
    local component=$1

    # If --only is specified, only install those components
    if [ ${#ONLY_COMPONENTS[@]:-0} -gt 0 ]; then
        for only in "${ONLY_COMPONENTS[@]:-}"; do
            if [ "$only" = "$component" ]; then
                return 0
            fi
        done
        return 1
    fi

    # If --skip is specified, skip those components
    if [ ${#SKIP_COMPONENTS[@]:-0} -gt 0 ]; then
        for skip in "${SKIP_COMPONENTS[@]:-}"; do
            if [ "$skip" = "$component" ]; then
                log_info "Skipping component: $component"
                return 1
            fi
        done
    fi

    return 0
}

# Execute command or show dry run
execute_or_dry_run() {
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would execute: $*"
    else
        "$@"
    fi
}

###########################################
# STEP FUNCTIONS
###########################################

initialQuestions() {
    # Show banner
    if command -v show_banner &> /dev/null; then
        show_banner
        echo ""
        show_header "Dotfiles Installation System" 75
    elif [ -f docs/title.txt ]; then
        cat docs/title.txt
    fi

    if [ "$NON_INTERACTIVE" = true ]; then
        log_info "Non-interactive mode: using defaults"
        OS="mac"
        USE_DESKTOP_ENV=FALSE
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
        os_choice=$(ui_choose "Choose your OS:" "Mac OSX" "Exit")
    else
        read -rp "[1] Mac OSX (default: exit) : " choice_num
        case $choice_num in
            1) os_choice="Mac OSX" ;;
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
            print_info "OS: Mac OSX"
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

setupDirectories() {
    log_info "Creating directories"

    mkdir -p "$HOME/Development"
    mkdir -p "$HOME/.tmux/plugins"

    # if [ "$USE_DESKTOP_ENV" = FALSE ]; then
    #     mkdir -p "$HOME/Pictures"
    #     mkdir -p "$HOME/Pictures/avatars"
    #     mkdir -p "$HOME/Pictures/wallpapers"
    # fi

    log_success "Directories created"
}

setupFzf() {
    printTopBorder
    log_info "Setting up FZF"
    printBottomBorder

    if [ -x "$(command -v brew)" ]; then
        "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
        log_success "FZF setup completed"
    fi
}

setupLua() {
    printTopBorder
    log_info "Setting up Lua"
    printBottomBorder

    if [ ! -d "$HOME/lua-language-server" ] || [ "$FORCE_INSTALL" = true ]; then
        retry_command git clone https://github.com/LuaLS/lua-language-server "$HOME/lua-language-server"
        cd "$HOME/lua-language-server" || exit 1
        git submodule update --init --recursive
        cd 3rd/luamake || exit 1
        compile/install.sh
        cd ../..
        ./3rd/luamake/luamake rebuild

        cd "$DOTFILES" || exit 1
        log_success "Lua language server installed"
    else
        log_info "Lua language server already installed, skipping"
    fi

    if [ "$(command -v luarocks)" ]; then
        luarocks install --server=https://luarocks.org/dev luaformatter
    fi
}

setupNeovim() {
    log_info "Setting up neovim dependencies"

    if [ "$(command -v python)" ]; then
        python -m pip install --upgrade pynvim
        log_success "Neovim dependencies installed"
    else
        log_warning "Python not found, skipping neovim python dependencies"
    fi
}

setupRust() {
    printTopBorder
    log_info "Setting up rust"
    printBottomBorder

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

setupShell() {
    printTopBorder
    log_info "Switching SHELL to zsh"
    printBottomBorder

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"

    if ! grep "$zsh_path" /etc/shells; then
        log_info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        log_success "default shell changed to $zsh_path"
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

setupStow() {
    log_info "Using stow to manage symlinking dotfiles"

    # Backup existing dotfiles before stowing
    backup_dotfiles

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
    fi
}

setupTmux() {
    printTopBorder
    log_info "Setting up tmux plugin manager"
    printBottomBorder

    if [ ! -d ~/.tmux/plugins/tpm ] || [ "$FORCE_INSTALL" = true ]; then
        retry_command git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        log_success "Tmux plugin manager installed"
    else
        log_info "tmux plugin manager already installed, skipping"
    fi
}

setupVolta() {
    printTopBorder
    log_info "Going to use Volta for managing node versions"
    printBottomBorder

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

setupClaudeCli() {
    printTopBorder
    log_info "Installing Claude Code CLI"
    printBottomBorder

    if [ ! -d "$HOME/.claude" ] || [ "$FORCE_INSTALL" = true ]; then
        retry_command curl -fsSL https://claude.ai/install.sh | bash
        log_success "Claude Code CLI installed"
    else
        log_info "Claude Code CLI already installed, skipping"
    fi
}

setupForMac() {
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
                cat ./scripts/vscode-extensions.txt | xargs -L1 code --install-extension
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
        execute_or_dry_run setupDirectories
    fi

    show_step "Installing development tools"
    should_install_component "claude" && execute_or_dry_run setupClaudeCli
    should_install_component "fzf" && execute_or_dry_run setupFzf
    should_install_component "lua" && execute_or_dry_run setupLua
    should_install_component "neovim" && execute_or_dry_run setupNeovim
    should_install_component "rust" && execute_or_dry_run setupRust

    if should_install_component "shell"; then
        show_step "Configuring shell (zsh + zap)"
        execute_or_dry_run setupShell
    fi

    if should_install_component "tmux"; then
        show_step "Setting up tmux"
        execute_or_dry_run setupTmux
    fi

    if should_install_component "volta"; then
        show_step "Setting up Node.js (Volta)"
        execute_or_dry_run setupVolta
    fi

    if should_install_component "stow"; then
        show_step "Symlinking dotfiles"
        execute_or_dry_run setupStow
    fi

    if should_install_component "macos-defaults"; then
        show_step "Configuring macOS defaults"
        # disables the hold key menu to allow key repeat
        execute_or_dry_run defaults write -g ApplePressAndHoldEnabled -bool false

        # The speed of repetition of characters
        execute_or_dry_run defaults write -g KeyRepeat -int 2

        # Delay until repeat
        execute_or_dry_run defaults write -g InitialKeyRepeat -int 15
        log_success "macOS defaults configured"
    fi

    echo ""
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                    Installation completed successfully! 🎉                 ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"
    log_success "Dotfiles installation completed"
}

###########################################
# INIT OF APPLICATION
###########################################

# Parse command line arguments first
parse_args "$@"

initialQuestions

if [ "$OS" = "mac" ]; then
    setupForMac
else
    echo "Something went wrong, try again and if it still fails, open an issue on Github"

    exit 1
fi
