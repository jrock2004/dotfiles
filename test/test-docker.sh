#!/bin/bash
# Docker Test Runner for Dotfiles
# Builds and runs dotfiles installation in Docker containers

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="$(dirname "$SCRIPT_DIR")"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Available distros
DISTROS=("ubuntu" "fedora" "arch")

show_help() {
    cat <<EOF
Docker Test Runner for Dotfiles

Usage: $0 [OPTIONS] [DISTRO]

Options:
  -h, --help          Show this help message
  --build             Build Docker image before testing
  --shell             Open shell in container instead of running tests
  --dry-run           Run installation with --dry-run flag

Distros:
  ubuntu              Test on Ubuntu 22.04
  fedora              Test on Fedora 39
  arch                Test on Arch Linux
  all                 Test on all distros (default)

Examples:
  $0 ubuntu           # Test on Ubuntu
  $0 --build all      # Rebuild images and test all distros
  $0 --shell fedora   # Open shell in Fedora container

EOF
    exit 0
}

build_image() {
    local distro=$1
    echo -e "${YELLOW}Building Docker image for $distro...${NC}"

    docker build \
        -f "$SCRIPT_DIR/Dockerfile.$distro" \
        -t "dotfiles-test:$distro" \
        "$DOTFILES"

    echo -e "${GREEN}✓ Built dotfiles-test:$distro${NC}"
}

run_test() {
    local distro=$1
    local dry_run=${2:-false}
    local shell_mode=${3:-false}

    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  Testing on $distro${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Prepare installation command
    local install_flags="--non-interactive"
    if [ "$dry_run" = true ]; then
        install_flags="$install_flags --dry-run"
    fi

    if [ "$shell_mode" = true ]; then
        # Open interactive shell
        docker run --rm -it \
            -v "$DOTFILES:/home/testuser/.dotfiles:ro" \
            "dotfiles-test:$distro" \
            /bin/bash
    else
        # Run installation and tests
        if docker run --rm \
            -v "$DOTFILES:/home/testuser/.dotfiles:ro" \
            "dotfiles-test:$distro" \
            /bin/bash -c "
                cd /home/testuser/.dotfiles && \
                echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' && \
                echo '  Running Installation' && \
                echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' && \
                ./install.sh $install_flags && \
                echo '' && \
                echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' && \
                echo '  Running Integration Tests' && \
                echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' && \
                ./scripts/test-integration.sh
            "; then
            echo -e "${GREEN}✅ Tests passed on $distro${NC}"
            return 0
        else
            echo -e "${RED}❌ Tests failed on $distro${NC}"
            return 1
        fi
    fi
}

# Parse arguments
BUILD=false
SHELL_MODE=false
DRY_RUN=false
SELECTED_DISTRO="all"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        --build)
            BUILD=true
            shift
            ;;
        --shell)
            SHELL_MODE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        ubuntu|fedora|arch|all)
            SELECTED_DISTRO=$1
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run '$0 --help' for usage information."
            exit 1
            ;;
    esac
done

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Error: Docker is not installed${NC}"
    echo "Please install Docker to run these tests."
    exit 1
fi

# Main
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║              Dotfiles Docker Test Runner                         ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

# Determine which distros to test
TEST_DISTROS=()
if [ "$SELECTED_DISTRO" = "all" ]; then
    TEST_DISTROS=("${DISTROS[@]}")
else
    TEST_DISTROS=("$SELECTED_DISTRO")
fi

# Build images if requested
if [ "$BUILD" = true ]; then
    for distro in "${TEST_DISTROS[@]}"; do
        build_image "$distro"
    done
fi

# Run tests
FAILED_DISTROS=()
for distro in "${TEST_DISTROS[@]}"; do
    if ! run_test "$distro" "$DRY_RUN" "$SHELL_MODE"; then
        FAILED_DISTROS+=("$distro")
    fi
done

# Summary
echo ""
echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║                        Test Summary                               ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

if [ ${#FAILED_DISTROS[@]} -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Tests failed on: ${FAILED_DISTROS[*]}${NC}"
    exit 1
fi
