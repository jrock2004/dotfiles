#!/usr/bin/env bash

# Gum Integration Wrapper
# Provides UI functions with graceful fallbacks: gum → fzf → bash built-ins

# Source UI library for colors and symbols
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ui.sh"

###########################################
# DETECTION FUNCTIONS
###########################################

has_gum() {
    command -v gum &> /dev/null
}

has_fzf() {
    command -v fzf &> /dev/null
}

###########################################
# WRAPPER FUNCTIONS
###########################################

# Choose from a list of options
# Usage: ui_choose "prompt" "option1" "option2" "option3"
ui_choose() {
    local prompt="$1"
    shift
    local options=("$@")

    if has_gum; then
        # Use gum choose
        gum choose --header="$prompt" "${options[@]}"
    elif has_fzf; then
        # Use fzf
        printf "%s\n" "${options[@]}" | fzf --prompt="$prompt > " --height=40% --reverse
    else
        # Use bash select
        echo "$prompt"
        select option in "${options[@]}"; do
            if [ -n "$option" ]; then
                echo "$option"
                break
            fi
        done
    fi
}

# Multi-select from a list of options
# Usage: ui_multi_select "prompt" "option1" "option2" "option3"
ui_multi_select() {
    local prompt="$1"
    shift
    local options=("$@")

    if has_gum; then
        # Use gum choose with --no-limit
        gum choose --no-limit --header="$prompt" "${options[@]}"
    elif has_fzf; then
        # Use fzf with multi-select
        printf "%s\n" "${options[@]}" | fzf --multi --prompt="$prompt > " --height=60% --reverse
    else
        # Use bash with manual multi-select
        echo "$prompt"
        echo "(Enter numbers separated by spaces, e.g., '1 3 5')"
        echo ""

        local i=1
        for option in "${options[@]}"; do
            echo "  $i) $option"
            ((i++))
        done

        echo ""
        read -rp "Your selection: " selection

        # Convert selection to options
        for num in $selection; do
            if [ "$num" -ge 1 ] && [ "$num" -le "${#options[@]}" ]; then
                echo "${options[$((num-1))]}"
            fi
        done
    fi
}

# Show a spinner while running a command
# Usage: ui_spin "message" command args...
ui_spin() {
    local message="$1"
    shift

    if has_gum; then
        # Use gum spin
        gum spin --spinner dot --title "$message" -- "$@"
    else
        # Run command in background and show custom spinner
        "$@" &
        local pid=$!
        spinner $pid "$message"
        return $?
    fi
}

# Ask for confirmation
# Usage: ui_confirm "Are you sure?" && echo "confirmed"
ui_confirm() {
    local prompt="$1"
    local default="${2:-No}"

    if has_gum; then
        # Use gum confirm
        if [ "$default" = "Yes" ]; then
            gum confirm "$prompt" --default=true
        else
            gum confirm "$prompt" --default=false
        fi
    else
        # Use custom confirm function from ui.sh
        if [ "$default" = "Yes" ]; then
            confirm "$prompt" "y"
        else
            confirm "$prompt" "n"
        fi
    fi
}

# Get text input from user
# Usage: name=$(ui_input "What's your name?")
ui_input() {
    local prompt="$1"
    local placeholder="${2:-}"
    local default="${3:-}"

    if has_gum; then
        # Use gum input
        if [ -n "$placeholder" ]; then
            gum input --placeholder="$placeholder" --prompt="$prompt: " --value="$default"
        else
            gum input --prompt="$prompt: " --value="$default"
        fi
    else
        # Use bash read
        if [ -n "$default" ]; then
            read -rp "$prompt [$default]: " response
            echo "${response:-$default}"
        else
            read -rp "$prompt: " response
            echo "$response"
        fi
    fi
}

# Show a filter/search interface
# Usage: result=$(ui_filter "Search..." < file.txt)
ui_filter() {
    local prompt="${1:-Filter}"

    if has_gum; then
        # Use gum filter
        gum filter --placeholder="$prompt"
    elif has_fzf; then
        # Use fzf
        fzf --prompt="$prompt > " --height=60% --reverse
    else
        # No filtering available, just cat
        cat
    fi
}

# Show styled output with gum style (or fallback to colors)
# Usage: ui_styled --foreground="212" --bold "Hello World"
ui_styled() {
    if has_gum; then
        gum style "$@"
    else
        # Simple fallback - just print the last argument
        echo "${@: -1}"
    fi
}

# Show a pager for long content
# Usage: echo "long content" | ui_pager
ui_pager() {
    if has_gum; then
        gum pager
    elif command -v less &> /dev/null; then
        less -R
    else
        cat
    fi
}

# Join items with a delimiter
# Usage: ui_join "," "item1" "item2" "item3"
ui_join() {
    if has_gum; then
        local delimiter="$1"
        shift
        gum join --horizontal --align left "$@" | sed "s/ /$delimiter/g"
    else
        local delimiter="$1"
        shift
        local result=""
        for item in "$@"; do
            if [ -z "$result" ]; then
                result="$item"
            else
                result="$result$delimiter$item"
            fi
        done
        echo "$result"
    fi
}

###########################################
# COMPONENT SELECTION HELPER
###########################################

# Select components interactively
# Returns: space-separated list of selected components
select_components() {
    local prompt="Select components to install:"

    # Define all available components with descriptions
    local -a components=(
        "directories:Create standard directories"
        "homebrew:Install Homebrew and packages"
        "vscode:Install VS Code extensions"
        "fonts:Install programming fonts"
        "claude:Install Claude Code CLI"
        "fzf:Install FZF fuzzy finder"
        "lua:Install Lua language server"
        "neovim:Install Neovim dependencies"
        "rust:Install Rust toolchain"
        "shell:Configure zsh and zap"
        "tmux:Install tmux plugin manager"
        "volta:Install Volta and Node.js"
        "stow:Symlink dotfiles"
        "macos-defaults:Configure macOS defaults"
    )

    if has_gum || has_fzf; then
        # Extract just the component names for selection
        local -a names=()
        for item in "${components[@]}"; do
            names+=("${item%%:*}")
        done

        # Show selection UI
        local selected=$(ui_multi_select "$prompt" "${names[@]}")

        # Return selected components
        echo "$selected" | tr '\n' ' '
    else
        # Fallback: show all components with descriptions
        echo "$prompt"
        echo ""

        local i=1
        for item in "${components[@]}"; do
            local name="${item%%:*}"
            local desc="${item#*:}"
            printf "  ${CYAN}%2d)${RESET} %-20s ${BLUE}%s${RESET}\n" $i "$name" "$desc"
            ((i++))
        done

        echo ""
        echo "Enter component numbers (space-separated, e.g., '1 3 5'), or press Enter for all:"
        read -rp "> " selection

        if [ -z "$selection" ]; then
            # Return all components
            for item in "${components[@]}"; do
                echo "${item%%:*}"
            done | tr '\n' ' '
        else
            # Return selected components
            for num in $selection; do
                if [ "$num" -ge 1 ] && [ "$num" -le "${#components[@]}" ]; then
                    echo "${components[$((num-1))]%%:*}"
                fi
            done | tr '\n' ' '
        fi
    fi
}

# Export functions for use in install.sh
export -f ui_choose
export -f ui_multi_select
export -f ui_spin
export -f ui_confirm
export -f ui_input
export -f ui_filter
export -f ui_styled
export -f ui_pager
export -f ui_join
export -f select_components
