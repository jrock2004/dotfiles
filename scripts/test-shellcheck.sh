#!/bin/bash
# Shellcheck Test Script
# Runs shellcheck on all shell scripts and generates a report

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"
REPORT_FILE="$DOTFILES/shellcheck-report.txt"

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                    Running ShellCheck                             ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Check if shellcheck is installed
if ! command -v shellcheck &> /dev/null; then
    echo "❌ Error: shellcheck is not installed"
    echo "Install with: brew install shellcheck"
    exit 1
fi

echo "✓ shellcheck version: $(shellcheck --version | grep version:)"
echo ""

# Find all shell scripts
echo "Finding shell scripts..."
SCRIPTS=(
    "$SCRIPT_DIR"/*.sh
    "$SCRIPT_DIR"/lib/*.sh
    "$SCRIPT_DIR"/components/*.sh
    "$SCRIPT_DIR"/os/*.sh
)

# Expand the array to get actual files
ALL_SCRIPTS=()
for pattern in "${SCRIPTS[@]}"; do
    for file in $pattern; do
        if [ -f "$file" ]; then
            ALL_SCRIPTS+=("$file")
        fi
    done
done

# Also check root wrapper scripts
for file in "$DOTFILES"/*.sh; do
    if [ -f "$file" ] && [ "$(basename "$file")" != "install-legacy.sh" ]; then
        ALL_SCRIPTS+=("$file")
    fi
done

echo "Found ${#ALL_SCRIPTS[@]} shell scripts"
echo ""

# Run shellcheck on all scripts
FAILED=0
PASSED=0
WARNINGS=0

echo "Running shellcheck..." > "$REPORT_FILE"
echo "Date: $(date)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

for script in "${ALL_SCRIPTS[@]}"; do
    RELATIVE_PATH="${script#"$DOTFILES"/}"

    # Capture shellcheck output (without -x flag for compatibility with older versions)
    SHELLCHECK_OUTPUT=$(shellcheck "$script" 2>&1)
    SHELLCHECK_EXIT=$?

    # Write to report file
    echo "=== $RELATIVE_PATH ===" >> "$REPORT_FILE"
    echo "$SHELLCHECK_OUTPUT" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    if [ $SHELLCHECK_EXIT -eq 0 ]; then
        echo "✓ $RELATIVE_PATH"
        PASSED=$((PASSED + 1))
    else
        if [ $SHELLCHECK_EXIT -eq 1 ]; then
            echo "✗ $RELATIVE_PATH (errors found)"
            # Show errors in output for CI visibility
            echo "$SHELLCHECK_OUTPUT"
            FAILED=$((FAILED + 1))
        else
            echo "⚠ $RELATIVE_PATH (warnings)"
            echo "$SHELLCHECK_OUTPUT"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
done

echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                        Results Summary                            ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""
echo "Total scripts checked: ${#ALL_SCRIPTS[@]}"
echo "✓ Passed: $PASSED"
echo "⚠ Warnings: $WARNINGS"
echo "✗ Failed: $FAILED"
echo ""
echo "Full report saved to: shellcheck-report.txt"

if [ $FAILED -gt 0 ]; then
    echo ""
    echo "❌ ShellCheck found errors. Please review the report."
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo ""
    echo "⚠️  ShellCheck found warnings. Review recommended."
    exit 0
else
    echo ""
    echo "✅ All scripts passed ShellCheck!"
    exit 0
fi
