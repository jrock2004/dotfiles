# Contributing to Dotfiles

Thank you for your interest in contributing to this dotfiles repository! Whether you're fixing bugs, adding new features, improving documentation, or adding support for new platforms, your contributions are welcome and appreciated.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Adding New Packages](#adding-new-packages)
- [Creating Package Mappings](#creating-package-mappings)
- [Adding New Components](#adding-new-components)
- [Testing](#testing)
- [Code Style Guidelines](#code-style-guidelines)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

This project follows a simple code of conduct:
- Be respectful and considerate
- Welcome newcomers and help them learn
- Focus on what is best for the community
- Show empathy towards others

## Getting Started

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/jrock2004/dotfiles.git
   ```
4. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Development Setup

1. **Install prerequisites** for your platform (see README.md)
2. **Run dry-run** to verify setup:
   ```bash
   ./install.sh --dry-run
   ```
3. **Test your changes** before committing

## Development Workflow

1. **Update your fork** before starting work:
   ```bash
   git checkout main
   git pull upstream main
   git push origin main
   ```

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/descriptive-name
   ```

3. **Make your changes** following the guidelines below

4. **Test your changes** thoroughly (see [Testing](#testing))

5. **Commit with descriptive messages**:
   ```bash
   git add .
   git commit -m "feat: Add support for XYZ"
   ```

6. **Push to your fork**:
   ```bash
   git push origin feature/descriptive-name
   ```

7. **Create a Pull Request** on GitHub

## Adding New Packages

### Cross-Platform Packages

For tools that should be available on **all platforms** (macOS, Linux, WSL):

1. **Add to `packages/common.txt`**:
   ```bash
   echo "your-package-name" >> packages/common.txt
   ```

2. **Create mappings** for platforms where package name differs (see [Creating Package Mappings](#creating-package-mappings))

3. **Validate** the package configuration:
   ```bash
   ./scripts/validate-packages.sh
   ```

4. **Test installation** on multiple platforms if possible:
   ```bash
   # macOS
   ./install.sh --only homebrew --force --dry-run

   # Linux (Docker)
   ./test/test-docker.sh ubuntu --build
   ```

**Example**: Adding `htop` (cross-platform monitoring tool)
```bash
# Add to common.txt
echo "htop" >> packages/common.txt

# Validate
./scripts/validate-packages.sh

# Test
./install.sh --only homebrew --dry-run
```

### Platform-Specific Packages

For packages that are **platform-specific**:

#### macOS-Specific

```bash
# CLI tools
echo "package-name" >> packages/macos/core.txt

# GUI applications (Homebrew casks)
echo "app-name" >> packages/macos/gui-apps.txt

# Fonts
echo "font-name" >> packages/macos/fonts.txt

# macOS-only tools (yabai, skhd, etc.)
echo "tool-name" >> packages/macos/macos-only.txt

# Homebrew taps (if needed)
echo "homebrew/tap-name" >> packages/macos/taps.txt
```

#### Linux-Specific

```bash
# Distribution packages
echo "package-name" >> packages/linux/core.txt

# GUI applications (native)
echo "app-name" >> packages/linux/gui-apps.txt

# Flatpak applications
echo "com.example.App" >> packages/linux/gui-apps-flatpak.txt

# Snap applications
echo "app-name" >> packages/linux/gui-apps-snap.txt
```

#### WSL-Specific

```bash
# WSL-specific utilities
echo "package-name" >> packages/wsl/wsl-specific.txt
```

### Optional Packages

For **nice-to-have** tools that may not be available on all platforms:

```bash
echo "optional-tool" >> packages/optional.txt
```

The installer will warn but continue if these packages are unavailable.

## Creating Package Mappings

When a package has **different names** across platforms, create a mapping:

### Mapping File Format

```
# Format: common-name=platform-specific-name
fd=fd-find
bat=batcat
ripgrep=rg
```

### Adding Mappings

1. **Identify the common name** (used in `packages/common.txt`)
2. **Find platform-specific names**:
   - Ubuntu/Debian: `apt-cache search <name>`
   - Fedora: `dnf search <name>`
   - Arch: `pacman -Ss <name>`
   - macOS: `brew search <name>`

3. **Add to appropriate mapping file**:
   ```bash
   # Ubuntu/Debian
   echo "fd=fd-find" >> packages/mappings/common-to-ubuntu.map

   # Fedora
   echo "fd=fd-find" >> packages/mappings/common-to-fedora.map

   # Arch (if different)
   echo "fd=fd" >> packages/mappings/common-to-arch.map

   # macOS (usually same as common name)
   echo "fd=fd" >> packages/mappings/common-to-macos.map
   ```

4. **Validate mappings**:
   ```bash
   ./scripts/validate-packages.sh
   ```

### Example: Adding `eza` (modern `ls` replacement)

```bash
# 1. Add to common.txt
echo "eza" >> packages/common.txt

# 2. Create mappings (if needed)
# Ubuntu - check if name differs
apt-cache search eza
# Fedora - check if name differs
dnf search eza
# Add mappings if different from "eza"

# 3. Validate
./scripts/validate-packages.sh
```

## Adding New Components

Components are modular installation units (e.g., `shell`, `neovim`, `tmux`).

### Creating a New Component

1. **Create component file** in `scripts/components/<name>.sh`:
   ```bash
   touch scripts/components/<name>.sh
   chmod +x scripts/components/<name>.sh
   ```

2. **Define component function**:
   ```bash
   #!/bin/bash
   # Component: <name>
   # Description: What this component does
   # Dependencies: list, of, dependencies
   # Platforms: macos, linux, wsl (or "all")

   setup_<name>() {
       local component="<name>"

       # Idempotency check
       if [ -f "$HOME/.<name>-installed" ] && [ "$FORCE_INSTALL" != "true" ]; then
           log_info "$component already installed (use --force to reinstall)"
           return 0
       fi

       log_info "Installing $component..."

       # Installation steps here
       # Example:
       # pkg_install "package-name" || {
       #     log_error "Failed to install package-name"
       #     return 1
       # }

       # Mark as installed
       touch "$HOME/.<name>-installed"

       log_success "$component installed successfully"
       return 0
   }
   ```

3. **Add to component list** in `scripts/install.sh`:
   ```bash
   # In show_help() function
   echo "  - <name>              Description of component"
   ```

4. **Add to OS orchestration** in `scripts/os/macos.sh`, `scripts/os/linux.sh`, or `scripts/os/wsl.sh`:
   ```bash
   # Source the component
   source "$SCRIPT_DIR/components/<name>.sh"

   # Add to installation sequence
   run_component "<name>" "setup_<name>"
   ```

5. **Document dependencies** in component file header

6. **Test the component**:
   ```bash
   ./install.sh --only <name> --dry-run
   ./install.sh --only <name> --force
   ```

### Component Best Practices

- **Make it idempotent**: Check if already installed, use `--force` to override
- **Handle errors gracefully**: Use `|| return 1` for critical failures
- **Log progress**: Use `log_info`, `log_success`, `log_warning`, `log_error`
- **Support dry-run**: Check `$DRY_RUN` variable before executing
- **Retry network operations**: Use `retry_command` for downloads
- **Document dependencies**: List in file header

### Example Component

See `scripts/components/shell.sh` or `scripts/components/tmux.sh` for complete examples.

## Testing

### Running Tests Locally

#### ShellCheck (Required)

All shell scripts must pass ShellCheck:

```bash
# Check all scripts
./scripts/test-shellcheck.sh

# Check specific script
shellcheck scripts/install.sh
```

**Fix common issues**:
- Quote variables: `"$VAR"` not `$VAR`
- Check exit codes: `command || handle_error`
- Use `[[ ]]` for tests, not `[ ]`

#### Integration Tests

Test that installation works correctly:

```bash
# Run all integration tests
./scripts/test-integration.sh

# This tests:
# - Dotfiles are symlinked correctly
# - Required binaries are installed
# - Shell is changed to zsh
# - Neovim starts without errors
# - Git, tmux, volta work correctly
```

#### Docker Tests

Test on multiple Linux distributions:

```bash
# Test on Ubuntu
./test/test-docker.sh ubuntu --build

# Test on Fedora
./test/test-docker.sh fedora --build

# Test on Arch
./test/test-docker.sh arch --build

# Test on all distros
for distro in ubuntu fedora arch; do
    ./test/test-docker.sh "$distro" --build
done

# Drop into shell for debugging
./test/test-docker.sh ubuntu --build --shell
```

#### Dry-Run Testing

Always test with dry-run before actual installation:

```bash
# Preview installation
./install.sh --dry-run

# Preview specific component
./install.sh --only <component> --dry-run

# Preview with different settings
DRY_RUN=true ./install.sh
```

### CI/CD Testing

Pull requests are automatically tested via GitHub Actions:
- **macOS**: Tests on macOS-latest
- **Linux**: Tests on ubuntu-latest
- **ShellCheck**: All scripts must pass
- **Dry-run**: Validates installation process
- **Package validation**: Checks package consistency

View CI results at: `.github/workflows/test-install.yml`

### Adding New Tests

To add new integration tests, edit `scripts/test-integration.sh`:

```bash
test_your_feature() {
    log_info "Testing your feature..."

    # Your test logic here
    if [ condition ]; then
        log_success "Feature test passed"
        return 0
    else
        log_error "Feature test failed"
        return 1
    fi
}

# Add to main test sequence
test_your_feature || exit 1
```

## Code Style Guidelines

### Shell Script Style

Follow the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) with these key points:

#### 1. Shebang and Settings

```bash
#!/bin/bash
# Description of script
# Exit on error, undefined variables, and pipe failures
set -euo pipefail
```

#### 2. Error Handling

```bash
# Use error handling
command || {
    log_error "Command failed"
    return 1
}

# Use trap for cleanup
trap cleanup_on_error ERR EXIT INT TERM
```

#### 3. Functions

```bash
# Function naming: lowercase with underscores
function_name() {
    local var="value"  # Use local for function variables

    # Do something
    return 0
}
```

#### 4. Variables

```bash
# Global variables: UPPERCASE
GLOBAL_VAR="value"

# Local variables: lowercase
local_var="value"

# Always quote variables
echo "$var"
echo "${var}"

# Use arrays properly
my_array=("item1" "item2")
for item in "${my_array[@]}"; do
    echo "$item"
done
```

#### 5. Conditionals

```bash
# Use [[ ]] for tests
if [[ "$var" == "value" ]]; then
    # Do something
fi

# Check exit codes
if command; then
    # Success
else
    # Failure
fi
```

#### 6. Logging

```bash
# Use logging functions
log_info "Information message"
log_success "Success message"
log_warning "Warning message"
log_error "Error message"
```

#### 7. Comments

```bash
# File header
#!/bin/bash
# Script: name.sh
# Description: What this script does
# Dependencies: what it needs
# Platforms: macos, linux, wsl

# Function documentation
# Description: What the function does
# Arguments: $1 - description
# Returns: 0 on success, 1 on failure
function_name() {
    # Implementation
}
```

### ShellCheck Rules

All scripts must pass ShellCheck with our configuration (`.shellcheckrc`):

**Disabled warnings** (with justification):
- `SC2155`: Declare and assign separately (allows `local var="$(command)"`)
- `SC2034`: Variable appears unused (for exported variables)
- `SC2086`: Double quote to prevent globbing (sometimes needed)
- `SC2059`: Don't use variables in printf format (allows dynamic formats)
- `SC2129`: Multiple redirects (allows `echo >> file` style)
- `SC1091`: Not following sourced files (can't follow dynamic sources)

**Enabled and enforced**:
- Quote all variables
- Check command exit codes
- Use `[[ ]]` for tests
- Proper array handling
- No unused variables (except exports)

### Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples**:
```bash
feat(packages): Add support for Neovim 0.10
fix(shell): Fix zsh plugin loading order
docs(readme): Update installation instructions
test(docker): Add Fedora 39 test
chore(ci): Update GitHub Actions versions
```

## Submitting Changes

### Pull Request Process

1. **Ensure all tests pass**:
   ```bash
   ./scripts/test-shellcheck.sh
   ./scripts/test-integration.sh
   ```

2. **Update documentation** if needed:
   - Update `README.md` for user-facing changes
   - Update `CLAUDE.md` for AI assistant context
   - Update `CONTRIBUTING.md` for contributor guidelines

3. **Validate package changes**:
   ```bash
   ./scripts/validate-packages.sh
   ```

4. **Create pull request** with:
   - Clear title following commit message format
   - Description of changes
   - Testing performed
   - Screenshots (if UI changes)
   - Breaking changes (if any)

5. **Address review feedback** promptly

6. **Squash commits** if requested

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing Performed
- [ ] ShellCheck passed
- [ ] Integration tests passed
- [ ] Docker tests passed (Ubuntu/Fedora/Arch)
- [ ] Tested on macOS
- [ ] Tested on Linux
- [ ] Tested on WSL

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review of code completed
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated as needed
- [ ] Commit messages follow conventional commits
```

## Additional Resources

- [README.md](README.md) - User-facing documentation
- [CLAUDE.md](CLAUDE.md) - AI assistant context
- [MIGRATION.md](MIGRATION.md) - Migration guide (to be created)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Conventional Commits](https://www.conventionalcommits.org/)

## Questions or Need Help?

- Open an issue for questions
- Check existing issues and PRs first
- Be specific and provide context
- Include error messages and logs

## License

By contributing, you agree that your contributions will be licensed under the same license as this project (MIT License).

---

Thank you for contributing! Your efforts help make this dotfiles repository better for everyone. 🎉
