#!/bin/bash
# Package management abstraction layer
# Provides unified interface across brew, apt, pacman, dnf, yum
# Dependencies: common.sh (for logging), detect.sh (for platform detection)

###########################################
# PACKAGE MANAGER DETECTION
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

###########################################
# PACKAGE FILE HANDLING
###########################################

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

###########################################
# PACKAGE INSTALLATION
###########################################

# Install a single package using the appropriate package manager
pkg_install_single() {
    local package=$1
    local pkg_manager=$(detect_package_manager)
    local mapped_package=$(get_mapped_package_name "$package")

    # Skip packages that shouldn't be installed on WSL
    if command -v should_skip_package &>/dev/null && should_skip_package "$package"; then
        log_info "Skipping $package (not needed on WSL)"
        return 0
    fi

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

###########################################
# HOMEBREW-SPECIFIC FUNCTIONS
###########################################

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

# Export functions
export -f detect_package_manager
export -f get_platform
export -f read_package_file
export -f get_mapped_package_name
export -f pkg_install_single
export -f pkg_install_from_file
export -f pkg_install_optional
export -f pkg_tap
export -f pkg_install_cask
