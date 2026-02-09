#!/usr/bin/env bash

# OS Detection Library
# Detects operating system, distribution, and architecture

###########################################
# OS DETECTION
###########################################

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macos"
            ;;
        Linux*)
            echo "linux"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Detect macOS type (Intel or ARM)
detect_macos_type() {
    if [ "$(uname -s)" = "Darwin" ]; then
        if [ "$(uname -m)" = "arm64" ]; then
            echo "arm"
        else
            echo "intel"
        fi
    fi
}

# Detect Linux distribution
detect_linux_distro() {
    if [ "$(uname -s)" != "Linux" ]; then
        return
    fi

    # Check for /etc/os-release (most modern distros)
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
        return
    fi

    # Fallback checks for older systems
    if [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/fedora-release ]; then
        echo "fedora"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/SuSE-release ]; then
        echo "suse"
    else
        echo "unknown"
    fi
}

# Detect Linux distribution version
detect_linux_version() {
    if [ "$(uname -s)" != "Linux" ]; then
        return
    fi

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$VERSION_ID"
    fi
}

# Detect if running in WSL
detect_wsl() {
    if [ -f /proc/version ]; then
        if grep -qi microsoft /proc/version; then
            echo "true"
            return
        fi
    fi
    echo "false"
}

# Detect WSL version (1 or 2)
detect_wsl_version() {
    if [ "$(detect_wsl)" = "true" ]; then
        if grep -qi "WSL2" /proc/version; then
            echo "2"
        else
            echo "1"
        fi
    fi
}

# Detect architecture
detect_arch() {
    local machine=$(uname -m)

    case "$machine" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        armv7l)
            echo "armv7"
            ;;
        i686|i386)
            echo "i386"
            ;;
        *)
            echo "$machine"
            ;;
    esac
}

# Get Homebrew prefix (macOS)
get_brew_prefix() {
    if command -v brew &> /dev/null; then
        brew --prefix
    elif [ "$(detect_macos_type)" = "arm" ]; then
        echo "/opt/homebrew"
    else
        echo "/usr/local"
    fi
}

###########################################
# SYSTEM INFO
###########################################

# Get number of CPU cores
get_cpu_cores() {
    case "$(detect_os)" in
        macos)
            sysctl -n hw.ncpu
            ;;
        linux)
            nproc
            ;;
        *)
            echo "1"
            ;;
    esac
}

# Get total memory in GB
get_total_memory() {
    case "$(detect_os)" in
        macos)
            echo $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))
            ;;
        linux)
            echo $(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 / 1024 ))
            ;;
        *)
            echo "0"
            ;;
    esac
}

# Check if running with sudo/root
is_root() {
    [ "$(id -u)" -eq 0 ]
}

# Check if user can sudo
can_sudo() {
    sudo -n true 2>/dev/null
}

###########################################
# EXPORT DETECTION RESULTS
###########################################

# Export all detection results as environment variables
export_system_info() {
    export DETECTED_OS=$(detect_os)
    export DETECTED_ARCH=$(detect_arch)
    export IS_WSL=$(detect_wsl)

    if [ "$DETECTED_OS" = "macos" ]; then
        export MACOS_TYPE=$(detect_macos_type)
        export BREW_PREFIX=$(get_brew_prefix)
        export DISTRO=""
        export DISTRO_VERSION=""
    elif [ "$DETECTED_OS" = "linux" ]; then
        export DISTRO=$(detect_linux_distro)
        export DISTRO_VERSION=$(detect_linux_version)
        export WSL_VERSION=$(detect_wsl_version)
        export BREW_PREFIX=""
        export MACOS_TYPE=""
    fi

    export CPU_CORES=$(get_cpu_cores)
    export TOTAL_MEMORY=$(get_total_memory)
}

###########################################
# DISPLAY FUNCTIONS
###########################################

# Show system information
show_system_info() {
    local os=$(detect_os)
    local arch=$(detect_arch)

    echo "System Information:"
    echo "  OS: $os"
    echo "  Architecture: $arch"

    if [ "$os" = "macos" ]; then
        echo "  macOS Type: $(detect_macos_type)"
        echo "  Homebrew Prefix: $(get_brew_prefix)"
    elif [ "$os" = "linux" ]; then
        echo "  Distribution: $(detect_linux_distro)"
        echo "  Version: $(detect_linux_version)"
        if [ "$(detect_wsl)" = "true" ]; then
            echo "  WSL: Version $(detect_wsl_version)"
        fi
    fi

    echo "  CPU Cores: $(get_cpu_cores)"
    echo "  Total Memory: $(get_total_memory)GB"
}

# Automatically export on source (if not disabled)
if [ "${DOTFILES_NO_AUTO_DETECT:-false}" != "true" ]; then
    export_system_info
fi
