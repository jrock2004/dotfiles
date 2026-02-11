#!/bin/bash
# Integration Tests for Dotfiles Installation
# Verifies that the installation completed successfully

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"
FAILED_TESTS=0
PASSED_TESTS=0

###########################################
# HELPER FUNCTIONS
###########################################

test_pass() {
    local test_name="$1"
    echo "✅ PASS: $test_name"
    PASSED_TESTS=$((PASSED_TESTS + 1))
}

test_fail() {
    local test_name="$1"
    local reason="$2"
    echo "❌ FAIL: $test_name - $reason"
    FAILED_TESTS=$((FAILED_TESTS + 1))
}

test_skip() {
    local test_name="$1"
    local reason="$2"
    echo "⊗ SKIP: $test_name - $reason"
}

###########################################
# TESTS
###########################################

test_dotfiles_symlinked() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Dotfiles Symlinks"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local files_to_check=(
        "$HOME/.zshrc"
        "$HOME/.zprofile"
        "$HOME/.gitconfig"
        "$HOME/.tmux.conf"
    )

    local all_symlinked=true

    for file in "${files_to_check[@]}"; do
        if [ -L "$file" ]; then
            echo "  ✓ $file is symlinked"
        elif [ -e "$file" ]; then
            echo "  ⚠ $file exists but is not a symlink"
            all_symlinked=false
        else
            echo "  ✗ $file does not exist"
            all_symlinked=false
        fi
    done

    if [ "$all_symlinked" = true ]; then
        test_pass "All required dotfiles are symlinked"
    else
        test_fail "Dotfiles symlinks" "Some files are missing or not symlinked"
    fi
}

test_required_binaries() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Required Binaries"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local required_binaries=(
        "git"
        "stow"
        "fzf"
        "zsh"
    )

    local all_installed=true

    for binary in "${required_binaries[@]}"; do
        if command -v "$binary" &> /dev/null; then
            echo "  ✓ $binary is installed ($(command -v "$binary"))"
        else
            echo "  ✗ $binary is NOT installed"
            all_installed=false
        fi
    done

    if [ "$all_installed" = true ]; then
        test_pass "All required binaries are installed"
    else
        test_fail "Required binaries" "Some binaries are missing"
    fi
}

test_optional_binaries() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Optional Binaries"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local optional_binaries=(
        "nvim"
        "tmux"
        "volta"
        "rustc"
        "gum"
    )

    for binary in "${optional_binaries[@]}"; do
        if command -v "$binary" &> /dev/null; then
            echo "  ✓ $binary is installed ($(command -v "$binary"))"
        else
            echo "  ⊗ $binary is not installed (optional)"
        fi
    done

    test_pass "Optional binaries check completed"
}

test_shell_is_zsh() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Shell Configuration"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [ -n "${SHELL:-}" ]; then
        echo "  Current SHELL: $SHELL"

        if [[ "$SHELL" == *"zsh"* ]]; then
            test_pass "Shell is set to zsh"
        else
            test_fail "Shell configuration" "SHELL is $SHELL, expected zsh"
        fi
    else
        test_fail "Shell configuration" "SHELL variable is not set"
    fi

    # Check if zsh is available
    if command -v zsh &> /dev/null; then
        echo "  ✓ zsh binary is available: $(command -v zsh)"
    else
        echo "  ✗ zsh binary is NOT available"
    fi
}

test_neovim_starts() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Neovim"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ! command -v nvim &> /dev/null; then
        test_skip "Neovim" "nvim not installed"
        return
    fi

    echo "  Testing if Neovim can start without errors..."

    # Use gtimeout if available (from coreutils), otherwise just test without timeout
    if command -v gtimeout &> /dev/null; then
        if gtimeout 10s nvim --headless +quit 2>&1; then
            test_pass "Neovim starts without errors"
        else
            test_fail "Neovim" "Failed to start or exited with error"
        fi
    elif nvim --headless +quit 2>&1; then
        test_pass "Neovim starts without errors"
    else
        test_fail "Neovim" "Failed to start or exited with error"
    fi
}

test_git_config() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Git Configuration"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if git config user.name &> /dev/null && git config user.email &> /dev/null; then
        echo "  ✓ Git user.name: $(git config user.name)"
        echo "  ✓ Git user.email: $(git config user.email)"
        test_pass "Git is configured"
    else
        test_fail "Git configuration" "user.name or user.email not set"
    fi
}

test_tmux_plugin_manager() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Tmux Plugin Manager"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ! command -v tmux &> /dev/null; then
        test_skip "Tmux" "tmux not installed"
        return
    fi

    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "  ✓ TPM is installed at ~/.tmux/plugins/tpm"
        test_pass "Tmux Plugin Manager is installed"
    else
        test_fail "Tmux Plugin Manager" "TPM not found at ~/.tmux/plugins/tpm"
    fi
}

test_volta_node() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Volta and Node.js"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if ! command -v volta &> /dev/null; then
        test_skip "Volta" "volta not installed"
        return
    fi

    echo "  ✓ Volta is installed: $(volta --version)"

    if command -v node &> /dev/null; then
        echo "  ✓ Node.js is installed: $(node --version)"
        test_pass "Volta and Node.js are working"
    else
        test_fail "Node.js" "Node.js not available via Volta"
    fi
}

test_directories_exist() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test: Standard Directories"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local directories=(
        "$HOME/.config"
        "$HOME/.local/bin"
        "$DOTFILES"
    )

    local all_exist=true

    for dir in "${directories[@]}"; do
        if [ -d "$dir" ]; then
            echo "  ✓ $dir exists"
        else
            echo "  ✗ $dir does NOT exist"
            all_exist=false
        fi
    done

    if [ "$all_exist" = true ]; then
        test_pass "All standard directories exist"
    else
        test_fail "Directories" "Some directories are missing"
    fi
}

###########################################
# MAIN
###########################################

main() {
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║              Dotfiles Integration Tests                          ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Running integration tests to verify installation..."

    # Run all tests
    test_directories_exist
    test_dotfiles_symlinked
    test_required_binaries
    test_optional_binaries
    test_shell_is_zsh
    test_git_config
    test_tmux_plugin_manager
    test_volta_node
    test_neovim_starts

    # Summary
    echo ""
    echo "╔════════════════════════════════════════════════════════════════════╗"
    echo "║                        Test Results                               ║"
    echo "╚════════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Total tests: $((PASSED_TESTS + FAILED_TESTS))"
    echo "✅ Passed: $PASSED_TESTS"
    echo "❌ Failed: $FAILED_TESTS"
    echo ""

    if [ $FAILED_TESTS -gt 0 ]; then
        echo "❌ Some tests failed. Please review the output above."
        exit 1
    else
        echo "✅ All tests passed!"
        exit 0
    fi
}

main
