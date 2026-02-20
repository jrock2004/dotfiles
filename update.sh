#!/bin/bash
# Dotfiles Update Script Wrapper
# This is a lightweight wrapper that delegates to the modular update script

# Exit on error
set -e

# Get the directory where this script is located
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Execute the update script
exec "$DOTFILES/scripts/update.sh" "$@"
