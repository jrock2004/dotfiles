#!/usr/bin/env bash

# Package Validation Script - Simple version
# Checks package files exist and shows statistics

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
PACKAGES_DIR="$DOTFILES/packages"

echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║                    Package System Validator                               ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo ""

# Function to count non-comment lines
count_packages() {
    local file=$1
    if [ -f "$file" ]; then
        grep -v '^#' "$file" | grep -v '^$' | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# Check package files exist
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Package Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

FILES=(
    "common.txt"
    "optional.txt"
    "macos/core.txt"
    "macos/gui-apps.txt"
    "macos/fonts.txt"
    "macos/macos-only.txt"
)

TOTAL_PACKAGES=0
for file in "${FILES[@]}"; do
    full_path="$PACKAGES_DIR/$file"
    count=$(count_packages "$full_path")
    TOTAL_PACKAGES=$((TOTAL_PACKAGES + count))

    if [ -f "$full_path" ]; then
        printf "✅ %-25s %3d packages\n" "$file" "$count"
    else
        printf "❌ %-25s MISSING\n" "$file"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Mapping Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

MAPPINGS=(
    "mappings/common-to-macos.map"
    "mappings/common-to-ubuntu.map"
    "mappings/common-to-arch.map"
    "mappings/common-to-fedora.map"
)

for file in "${MAPPINGS[@]}"; do
    full_path="$PACKAGES_DIR/$file"
    if [ -f "$full_path" ]; then
        printf "✅ %s\n" "$(basename $file)"
    else
        printf "❌ %s MISSING\n" "$(basename $file)"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Total packages: $TOTAL_PACKAGES"
echo ""
echo "✅ Package system validation complete!"
