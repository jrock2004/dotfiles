#!/bin/bash
# Dotfiles Installation Script Wrapper
# This is a lightweight wrapper that delegates to the modular installation system

# Exit on error
set -e

# Get the directory where this script is located
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Execute the new modular installation script
exec "$DOTFILES/scripts/install.sh" "$@"
