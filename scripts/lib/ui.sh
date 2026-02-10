#!/usr/bin/env bash

# UI Library for dotfiles installation
# Provides colors, symbols, and styled output functions

###########################################
# COLOR CONSTANTS
###########################################

# Check if terminal supports colors
if [[ -t 1 ]] && command -v tput &> /dev/null && tput setaf 1 &>/dev/null; then
    BOLD=$(tput bold)
    RESET=$(tput sgr0)

    # Foreground colors
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    MAGENTA=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)

    # Background colors
    BG_BLACK=$(tput setab 0)
    BG_RED=$(tput setab 1)
    BG_GREEN=$(tput setab 2)
    BG_YELLOW=$(tput setab 3)
    BG_BLUE=$(tput setab 4)
    BG_MAGENTA=$(tput setab 5)
    BG_CYAN=$(tput setab 6)
    BG_WHITE=$(tput setab 7)
else
    # No color support
    BOLD=""
    RESET=""
    BLACK=""
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    MAGENTA=""
    CYAN=""
    WHITE=""
    BG_BLACK=""
    BG_RED=""
    BG_GREEN=""
    BG_YELLOW=""
    BG_BLUE=""
    BG_MAGENTA=""
    BG_CYAN=""
    BG_WHITE=""
fi

###########################################
# SYMBOL CONSTANTS
###########################################

CHECK_MARK="✓"
CROSS_MARK="✗"
ARROW="→"
INFO="ℹ"
WARNING="⚠"
ROCKET="🚀"
PACKAGE="📦"
WRENCH="🔧"
SPARKLES="✨"

###########################################
# UI HELPER FUNCTIONS
###########################################

# Show a styled header with optional ASCII art
show_header() {
    local title="$1"
    local width=${2:-75}

    echo ""
    echo "${CYAN}${BOLD}╔$(printf '═%.0s' $(seq 1 $width))╗${RESET}"

    # Center the title
    local title_len=${#title}
    local padding=$(( (width - title_len) / 2 ))
    printf "${CYAN}${BOLD}║${RESET}%*s${BOLD}%s${RESET}%*s${CYAN}${BOLD}║${RESET}\n" \
        $padding "" "$title" $(( width - title_len - padding )) ""

    echo "${CYAN}${BOLD}╚$(printf '═%.0s' $(seq 1 $width))╝${RESET}"
    echo ""
}

# Show a boxed message
box() {
    local message="$1"
    local color="${2:-$CYAN}"
    local width=${3:-75}

    echo ""
    echo "${color}╔$(printf '═%.0s' $(seq 1 $width))╗${RESET}"
    echo "${color}║${RESET} ${message}${color}$(printf ' %.0s' $(seq 1 $(( width - ${#message} - 1 ))))║${RESET}"
    echo "${color}╚$(printf '═%.0s' $(seq 1 $width))╝${RESET}"
    echo ""
}

# Show a progress bar
show_progress() {
    local current=$1
    local total=$2
    local width=${3:-50}

    local percentage=$(( current * 100 / total ))
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))

    printf "\r${CYAN}Progress:${RESET} ["
    printf "${GREEN}%0.s█${RESET}" $(seq 1 $filled)
    printf "%0.s░" $(seq 1 $empty)
    printf "] ${BOLD}%3d%%${RESET} (%d/%d)" $percentage $current $total

    if [ $current -eq $total ]; then
        echo ""
    fi
}

# Show a spinner for long-running tasks
spinner() {
    local pid=$1
    local message="${2:-Working}"
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

    while ps -p $pid > /dev/null 2>&1; do
        local temp=${spinstr#?}
        printf "\r${CYAN}%c${RESET} %s..." "$spinstr" "$message"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done

    wait $pid
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        printf "\r${GREEN}${CHECK_MARK}${RESET} %s... ${GREEN}Done${RESET}\n" "$message"
    else
        printf "\r${RED}${CROSS_MARK}${RESET} %s... ${RED}Failed${RESET}\n" "$message"
    fi

    return $exit_code
}

# Print colored status messages
print_success() {
    echo "${GREEN}${CHECK_MARK}${RESET} $1"
}

print_error() {
    echo "${RED}${CROSS_MARK}${RESET} $1" >&2
}

print_warning() {
    echo "${YELLOW}${WARNING}${RESET}  $1"
}

print_info() {
    echo "${BLUE}${INFO}${RESET}  $1"
}

print_step() {
    echo "${MAGENTA}${ARROW}${RESET} $1"
}

# Print a horizontal rule
hr() {
    local char="${1:--}"
    local width=${2:-75}
    printf "${CYAN}%${width}s${RESET}\n" | tr ' ' "$char"
}

# Print a section header
section() {
    local title="$1"
    echo ""
    hr "━"
    echo "${BOLD}${CYAN}  $title${RESET}"
    hr "━"
    echo ""
}

# Print a subsection
subsection() {
    local title="$1"
    echo ""
    echo "${BOLD}${BLUE}▸ $title${RESET}"
    echo ""
}

# Print a list item
list_item() {
    echo "  ${CYAN}•${RESET} $1"
}

# Ask for confirmation (y/n)
confirm() {
    local prompt="$1"
    local default="${2:-n}"

    if [ "$default" = "y" ]; then
        local prompt_suffix="[Y/n]"
    else
        local prompt_suffix="[y/N]"
    fi

    while true; do
        read -rp "${YELLOW}${WARNING}${RESET}  $prompt $prompt_suffix: " response
        response=${response:-$default}

        case "$response" in
            [yY]|[yY][eE][sS])
                return 0
                ;;
            [nN]|[nN][oO])
                return 1
                ;;
            *)
                print_error "Please answer yes or no"
                ;;
        esac
    done
}

# Show an ASCII banner
show_banner() {
    cat << 'EOF'
      ▓█████▄  ▒█████  ▄▄▄█████▓  █████▒██▓ ██▓    ▓█████   ██████
      ▒██▀ ██▌▒██▒  ██▒▓  ██▒ ▓▒▓██   ▒▓██▒▓██▒    ▓█   ▀ ▒██    ▒
      ░██   █▌▒██░  ██▒▒ ▓██░ ▒░▒████ ░▒██▒▒██░    ▒███   ░ ▓██▄
      ░▓█▄   ▌▒██   ██░░ ▓██▓ ░ ░▓█▒  ░░██░▒██░    ▒▓█  ▄   ▒   ██▒
      ░▒████▓ ░ ████▓▒░  ▒██▒ ░ ░▒█░   ░██░░██████▒░▒████▒▒██████▒▒
      ▒▒▓  ▒ ░ ▒░▒░▒░   ▒ ░░    ▒ ░   ░▓  ░ ▒░▓  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
      ░ ▒  ▒   ░ ▒ ▒░     ░     ░      ▒ ░░ ░ ▒  ░ ░ ░  ░░ ░▒  ░ ░
      ░ ░  ░ ░ ░ ░ ▒    ░       ░ ░    ▒ ░  ░ ░      ░   ░  ░  ░
        ░        ░ ░                   ░      ░  ░   ░  ░      ░
      ░
EOF
}
