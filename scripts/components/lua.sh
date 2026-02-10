#!/bin/bash
# Component: Lua
# Description: Install Lua language server (complex build process with submodules)
# Dependencies: git, curl, luarocks (optional)

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

###########################################
# SETUP FUNCTION
###########################################

setup_lua() {
    printTopBorder
    log_info "Setting up Lua"
    printBottomBorder

    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would clone and build lua-language-server"
        echo "[DRY RUN] Would install luaformatter via luarocks (if available)"
        return 0
    fi

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

# Export setup function
export -f setup_lua
