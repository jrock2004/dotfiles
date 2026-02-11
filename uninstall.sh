#!/bin/bash
# Dotfiles Uninstall Script Wrapper
# This is a lightweight wrapper that delegates to the modular uninstall script

# Exit on error
set -e

# Get the directory where this script is located
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Execute the uninstall script
exec "$DOTFILES/scripts/uninstall.sh" "$@"
