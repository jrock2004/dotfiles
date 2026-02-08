# Package Name Mappings

This directory contains mapping files that translate package names from `common.txt` to platform-specific package names.

## Purpose

Different package managers use different names for the same software. For example:
- `fd` on Homebrew/Arch = `fd-find` on Ubuntu/Debian
- `bat` on Homebrew/Arch = `batcat` on Ubuntu/Debian
- `gh` on Homebrew = `github-cli` on Arch

These mapping files ensure the correct package names are used on each platform.

## File Format

Each mapping file uses a simple `key=value` format:

```
# Comments start with #
common-package-name=platform-specific-name
fd=fd-find
bat=batcat
```

## Mapping Files

- `common-to-macos.map` - Homebrew package names
- `common-to-ubuntu.map` - Ubuntu/Debian (apt) package names
- `common-to-arch.map` - Arch Linux (pacman) package names
- `common-to-fedora.map` - Fedora/RHEL (dnf) package names

## Usage

The install script will:
1. Read packages from `common.txt`
2. Check if a mapping exists for the target platform
3. Use the mapped name if it exists, otherwise use the common name
4. Install the package using the appropriate package manager

## Adding New Mappings

When adding a package to `common.txt`, check if it has different names on other platforms:

1. Look up the package name on each platform
2. If it differs, add a mapping to the appropriate file
3. Run `./scripts/validate-packages.sh` to verify

## Examples

### Ubuntu Mapping
```bash
# In common.txt
fd

# In common-to-ubuntu.map
fd=fd-find

# Result: installs 'fd-find' on Ubuntu
```

### Arch Mapping
```bash
# In common.txt
gh

# In common-to-arch.map
gh=github-cli

# Result: installs 'github-cli' on Arch
```
