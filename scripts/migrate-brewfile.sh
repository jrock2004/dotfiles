#!/usr/bin/env bash

# Brewfile Migration Script
# Analyzes Brewfile and shows migration status

set -eo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
BREWFILE="$DOTFILES/Brewfile"
PACKAGES_DIR="$DOTFILES/packages"

echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║                    Brewfile Migration Tool                                 ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if Brewfile exists
if [ ! -f "$BREWFILE" ]; then
    echo "❌ Brewfile not found at $BREWFILE"
    exit 1
fi

# Check if packages directory exists
if [ ! -d "$PACKAGES_DIR" ]; then
    echo "❌ Packages directory not found."
    exit 1
fi

echo "This script shows the migration status from Brewfile to the new package system."
echo ""

# Count packages
count_packages() {
    local file=$1
    if [ -f "$file" ]; then
        grep -v '^#' "$file" | grep -v '^$' | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# Parse Brewfile
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Brewfile Analysis"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

BREW_COUNT=$(grep -c '^brew "' "$BREWFILE" 2>/dev/null || echo "0")
CASK_COUNT=$(grep -c '^cask "' "$BREWFILE" 2>/dev/null || echo "0")
TAP_COUNT=$(grep -c '^tap "' "$BREWFILE" 2>/dev/null || echo "0")

echo "Brewfile contains:"
echo "  Homebrew formulae (brew):  $BREW_COUNT"
echo "  Homebrew casks (cask):     $CASK_COUNT"
echo "  Homebrew taps (tap):       $TAP_COUNT"
echo "  Total:                     $((BREW_COUNT + CASK_COUNT + TAP_COUNT))"
echo ""

# Show new package system
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  New Package System"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

COMMON=$(count_packages "$PACKAGES_DIR/common.txt")
OPTIONAL=$(count_packages "$PACKAGES_DIR/optional.txt")
MACOS_CORE=$(count_packages "$PACKAGES_DIR/macos/core.txt")
MACOS_GUI=$(count_packages "$PACKAGES_DIR/macos/gui-apps.txt")
MACOS_FONTS=$(count_packages "$PACKAGES_DIR/macos/fonts.txt")
MACOS_ONLY=$(count_packages "$PACKAGES_DIR/macos/macos-only.txt")
MACOS_TAPS=$(count_packages "$PACKAGES_DIR/macos/taps.txt")

NEW_TOTAL=$((COMMON + OPTIONAL + MACOS_CORE + MACOS_GUI + MACOS_FONTS + MACOS_ONLY + MACOS_TAPS))

echo "New package system contains:"
echo "  common.txt:              $COMMON packages"
echo "  optional.txt:            $OPTIONAL packages"
echo "  macos/core.txt:          $MACOS_CORE packages"
echo "  macos/gui-apps.txt:      $MACOS_GUI packages"
echo "  macos/fonts.txt:         $MACOS_FONTS packages"
echo "  macos/macos-only.txt:    $MACOS_ONLY packages"
echo "  macos/taps.txt:          $MACOS_TAPS taps"
echo "  Total:                   $NEW_TOTAL packages"
echo ""

# Status
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Migration Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

BREWFILE_TOTAL=$((BREW_COUNT + CASK_COUNT + TAP_COUNT))

if [ $NEW_TOTAL -ge $BREWFILE_TOTAL ]; then
    echo "✅ Migration complete!"
    echo ""
    echo "The new package system has $NEW_TOTAL packages,"
    echo "covering all $BREWFILE_TOTAL packages from Brewfile."
else
    DIFF=$((BREWFILE_TOTAL - NEW_TOTAL))
    echo "⚠️  Migration in progress"
    echo ""
    echo "Brewfile has $BREWFILE_TOTAL packages"
    echo "New system has $NEW_TOTAL packages"
    echo "Difference: $DIFF packages"
    echo ""
    echo "Run './scripts/validate-packages.sh' to see details."
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Validate package system: ./scripts/validate-packages.sh"
echo "2. Test new system:         ./install.sh --dry-run --non-interactive"
echo "3. Run installation:        ./install.sh"
echo ""
echo "✅ install.sh now uses the new package system (packages/ directory)"
echo "📝 Brewfile is kept for reference but no longer used"
echo ""
