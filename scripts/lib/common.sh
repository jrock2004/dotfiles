#!/bin/bash
# Common utilities library
# Provides: logging, helpers, backup, retry logic, error handling
# Dependencies: None (base layer)

###########################################
# GLOBAL VARIABLES
###########################################

# Note: DOTFILES and SCRIPT_DIR should be set by the caller (install.sh)
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
LOG_FILE="${LOG_FILE:-$DOTFILES/.install.log}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)}"
CURRENT_STEP="${CURRENT_STEP:-0}"
TOTAL_STEPS="${TOTAL_STEPS:-10}"

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
# COMPONENT CONTROL
###########################################

# Check if a component should be installed
should_install_component() {
    local component=$1

    # If ONLY_COMPONENTS is set, only install those
    if [ ${#ONLY_COMPONENTS[@]} -gt 0 ]; then
        for only_comp in "${ONLY_COMPONENTS[@]}"; do
            if [ "$only_comp" = "$component" ]; then
                return 0
            fi
        done
        return 1
    fi

    # If SKIP_COMPONENTS is set, skip those
    if [ ${#SKIP_COMPONENTS[@]} -gt 0 ]; then
        for skip_comp in "${SKIP_COMPONENTS[@]}"; do
            if [ "$skip_comp" = "$component" ]; then
                log_info "Skipping component: $component"
                return 1
            fi
        done
    fi

    return 0
}

# Execute command or show dry-run message
execute_or_dry_run() {
    local description="$1"
    shift  # Remove first argument, rest is the command

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would execute: $description"
        return 0
    fi

    "$@"
}

# Export all functions for use by other scripts
export -f lowercase
export -f printBottomBorder
export -f printTopBorder
export -f log
export -f log_success
export -f log_error
export -f log_warning
export -f log_info
export -f show_step
export -f backup_dotfiles
export -f retry_command
export -f should_install_component
export -f execute_or_dry_run
export -f error_handler
export -f cleanup_on_error
