#!/usr/bin/env bash

# WSL-Specific Setup Library
# Handles WSL-specific configurations and integrations

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# CONSTANTS
###########################################

readonly WSL_CONF="/etc/wsl.conf"
readonly SUDOERS_WSL="/etc/sudoers.d/wsl"

###########################################
# WSL DETECTION HELPERS
###########################################

# Check if we're in WSL (wrapper for detect.sh)
is_wsl() {
    [ "${IS_WSL:-$(detect_wsl)}" = "true" ]
}

# Check if we're in WSL2 (wrapper for detect.sh)
is_wsl2() {
    [ "${WSL_VERSION:-$(detect_wsl_version)}" = "2" ]
}

###########################################
# SYSTEMD SETUP (WSL2)
###########################################

# Enable systemd on WSL2
setup_wsl_systemd() {
    if ! is_wsl2; then
        log_info "Systemd setup only available on WSL2, skipping"
        return 0
    fi

    log_info "Configuring systemd for WSL2"

    # Check if systemd is already enabled
    if [ -f "$WSL_CONF" ] && grep -q "systemd=true" "$WSL_CONF"; then
        log_success "Systemd already enabled in $WSL_CONF"
        return 0
    fi

    # Create or update /etc/wsl.conf
    local temp_conf=$(mktemp)
    cat > "$temp_conf" << 'EOF'
[boot]
systemd=true

[automount]
enabled=true
options="metadata,umask=22,fmask=11"

[network]
generateHosts=true
generateResolvConf=true

[interop]
enabled=true
appendWindowsPath=true
EOF

    # Install wsl.conf (requires sudo)
    if sudo cp "$temp_conf" "$WSL_CONF"; then
        rm "$temp_conf"
        log_success "Systemd enabled in $WSL_CONF"
        log_warning "You need to restart WSL for systemd to take effect"
        log_info "Run: wsl --shutdown (from Windows)"
    else
        rm "$temp_conf"
        log_error "Failed to enable systemd (permission denied)"
        return 1
    fi
}

###########################################
# WINDOWS INTEROP
###########################################

# Configure Windows interop
setup_windows_interop() {
    if ! is_wsl; then
        return 0
    fi

    log_info "Configuring Windows interop"

    # Set browser to Windows default browser
    export BROWSER="explorer.exe"

    # Add to shell config if not already present
    local zshrc="$HOME/.zshrc"
    if [ -f "$zshrc" ]; then
        if ! grep -q "BROWSER=.*explorer.exe" "$zshrc"; then
            echo "" >> "$zshrc"
            echo "# WSL Windows interop" >> "$zshrc"
            echo 'export BROWSER="explorer.exe"' >> "$zshrc"
            log_success "Added BROWSER export to .zshrc"
        fi
    fi

    # Create alias for clipboard access
    if ! grep -q "alias clip=" "$zshrc" 2>/dev/null; then
        echo 'alias clip="clip.exe"' >> "$zshrc"
        echo 'alias pbcopy="clip.exe"' >> "$zshrc"
        log_success "Added clipboard aliases to .zshrc"
    fi

    log_success "Windows interop configured"
}

# Setup Windows path helpers
setup_windows_paths() {
    if ! is_wsl; then
        return 0
    fi

    log_info "Setting up Windows path helpers"

    local funcs_dir="$HOME/.dotfiles/zsh/functions"
    mkdir -p "$funcs_dir"

    # Function to convert WSL path to Windows path
    cat > "$funcs_dir/winpath" << 'EOF'
# Convert WSL path to Windows path
wslpath -w "$@"
EOF

    # Function to convert Windows path to WSL path
    cat > "$funcs_dir/wslpath" << 'EOF'
# Convert Windows path to WSL path
wslpath -u "$@"
EOF

    # Function to open Windows Explorer in current directory
    cat > "$funcs_dir/explorer" << 'EOF'
# Open Windows Explorer in current directory
explorer.exe "${1:-.}"
EOF

    chmod +x "$funcs_dir/winpath" "$funcs_dir/wslpath" "$funcs_dir/explorer"

    log_success "Windows path helpers created"
}

###########################################
# CLOCK DRIFT FIX
###########################################

# Fix WSL clock drift issues
fix_wsl_clock_drift() {
    if ! is_wsl; then
        return 0
    fi

    log_info "Fixing WSL clock drift"

    # Sync time with hardware clock
    if sudo hwclock -s 2>/dev/null; then
        log_success "Clock synchronized with hardware clock"
    else
        log_warning "Could not sync with hardware clock (may not be needed on WSL2)"
    fi

    # Create systemd service for automatic time sync (WSL2 only)
    if is_wsl2; then
        local service_file="/etc/systemd/system/wsl-clock-sync.service"
        local timer_file="/etc/systemd/system/wsl-clock-sync.timer"

        # Create service
        sudo tee "$service_file" > /dev/null << 'EOF'
[Unit]
Description=Sync WSL clock with hardware clock
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/hwclock -s

[Install]
WantedBy=multi-user.target
EOF

        # Create timer
        sudo tee "$timer_file" > /dev/null << 'EOF'
[Unit]
Description=Sync WSL clock every hour

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
EOF

        # Enable and start timer
        sudo systemctl daemon-reload
        sudo systemctl enable wsl-clock-sync.timer 2>/dev/null || true
        sudo systemctl start wsl-clock-sync.timer 2>/dev/null || true

        log_success "Automatic clock sync configured"
    fi
}

###########################################
# DISPLAY AND AUDIO
###########################################

# Check if WSL needs to skip GUI features
should_skip_gui() {
    if ! is_wsl; then
        return 1  # Not WSL, don't skip
    fi

    # WSL2 with WSLg supports GUI
    if is_wsl2 && [ -n "$DISPLAY" ]; then
        return 1  # WSLg available, don't skip
    fi

    # WSL1 or no display
    return 0  # Skip GUI features
}

# Setup WSLg (WSL2 GUI support)
setup_wslg() {
    if ! is_wsl2; then
        log_info "WSLg only available on WSL2, skipping"
        return 0
    fi

    log_info "Checking WSLg support"

    if [ -n "$DISPLAY" ]; then
        log_success "WSLg detected (DISPLAY=$DISPLAY)"

        # Install GUI dependencies if needed
        case "${DISTRO}" in
            ubuntu|debian)
                sudo apt-get update -qq
                sudo apt-get install -y -qq \
                    libgl1-mesa-glx \
                    libglib2.0-0 \
                    libsm6 \
                    libxrender1 \
                    libxext6 \
                    2>/dev/null || true
                ;;
        esac

        log_success "WSLg ready for GUI applications"
    else
        log_info "WSLg not available (no DISPLAY variable)"
        log_info "GUI applications will not work without WSLg or X server"
    fi
}

###########################################
# PERFORMANCE OPTIMIZATIONS
###########################################

# Configure WSL performance settings
optimize_wsl_performance() {
    if ! is_wsl; then
        return 0
    fi

    log_info "Optimizing WSL performance"

    # Create .wslconfig in Windows user directory (if accessible)
    local windows_user_dir="/mnt/c/Users"
    local username=""

    # Try to find Windows username
    if [ -d "$windows_user_dir" ]; then
        for dir in "$windows_user_dir"/*; do
            local dirname=$(basename "$dir")
            if [[ "$dirname" != "Public" && "$dirname" != "Default" && "$dirname" != "All Users" ]]; then
                username="$dirname"
                break
            fi
        done
    fi

    if [ -n "$username" ]; then
        local wslconfig="/mnt/c/Users/$username/.wslconfig"

        if [ ! -f "$wslconfig" ]; then
            log_info "Creating optimized .wslconfig"

            cat > "$wslconfig" << 'EOF'
[wsl2]
# Limit memory to 50% of total RAM
memory=8GB

# Limit processors
processors=4

# Enable swap
swap=2GB

# Disable page reporting (can improve performance)
pageReporting=false

# Set swap file location
swapFile=C:\\temp\\wsl-swap.vhdx

# Enable nested virtualization
nestedVirtualization=true
EOF

            log_success "Created .wslconfig at $wslconfig"
            log_warning "Restart WSL for changes to take effect: wsl --shutdown"
        else
            log_info ".wslconfig already exists at $wslconfig"
        fi
    else
        log_warning "Could not determine Windows username, skipping .wslconfig"
    fi
}

###########################################
# PACKAGE FILTERS
###########################################

# Get list of packages to skip on WSL
get_wsl_skip_packages() {
    # Packages that don't work or aren't needed on WSL
    cat << 'EOF'
# Display managers
lightdm
gdm
sddm

# Audio servers
pulseaudio
pipewire

# System services
systemd-resolved

# Hardware utilities
bluez
bluetooth
EOF
}

# Check if a package should be skipped on WSL
should_skip_package() {
    local package="$1"

    if ! is_wsl; then
        return 1  # Not WSL, don't skip
    fi

    # Check against skip list
    if get_wsl_skip_packages | grep -q "^${package}$"; then
        return 0  # Skip this package
    fi

    return 1  # Don't skip
}

###########################################
# MAIN SETUP
###########################################

# Run all WSL setup functions
setup_wsl() {
    if ! is_wsl; then
        log_info "Not running in WSL, skipping WSL-specific setup"
        return 0
    fi

    log_header "WSL-Specific Setup"

    # Show WSL info
    log_info "WSL Version: $(detect_wsl_version)"
    log_info "Distribution: ${DISTRO}"

    # Run setup functions
    setup_wsl_systemd || true
    setup_windows_interop || true
    setup_windows_paths || true
    fix_wsl_clock_drift || true
    setup_wslg || true
    optimize_wsl_performance || true

    log_success "WSL-specific setup complete"

    # Show restart message if needed
    if is_wsl2; then
        echo ""
        log_warning "Some changes require WSL restart to take effect"
        log_info "From Windows, run: wsl --shutdown"
        log_info "Then restart your WSL distribution"
    fi
}

###########################################
# UTILITIES
###########################################

# Check if running in Windows Terminal
is_windows_terminal() {
    [ -n "${WT_SESSION:-}" ]
}

# Get Windows username
get_windows_username() {
    if is_wsl; then
        cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n'
    fi
}

# Get Windows home directory
get_windows_home() {
    if is_wsl; then
        local winuser=$(get_windows_username)
        echo "/mnt/c/Users/$winuser"
    fi
}
