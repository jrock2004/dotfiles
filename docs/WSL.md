# WSL-Specific Documentation

This guide covers Windows Subsystem for Linux (WSL) specific features, configurations, and troubleshooting for the dotfiles.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [WSL1 vs WSL2](#wsl1-vs-wsl2)
- [Installation](#installation)
- [WSL Configuration](#wsl-configuration)
- [Windows Integration](#windows-integration)
- [Performance Optimization](#performance-optimization)
- [Troubleshooting](#troubleshooting)
- [Tips and Tricks](#tips-and-tricks)

## Overview

The dotfiles fully support both WSL1 and WSL2 with automatic detection and WSL-specific configurations:

**Supported Features**:
- **Automatic WSL Detection**: Detects WSL1 vs WSL2
- **systemd Support**: Enables systemd on WSL2
- **Windows Interop**: Clipboard, browser, file access
- **Path Integration**: Access Windows executables from WSL
- **Network Configuration**: Proper DNS and network setup
- **File System Optimization**: Handles cross-OS file systems

**Supported Distributions**:
- Ubuntu (20.04, 22.04, 24.04)
- Debian (11, 12)
- Fedora (38, 39, 40)
- Arch Linux
- Any distro using apt, dnf, or pacman

## Prerequisites

### Windows Requirements

**Windows Version**:
- **WSL2**: Windows 10 version 1903+ or Windows 11 (recommended)
- **WSL1**: Windows 10 version 1607+

**Enable WSL**:
```powershell
# Windows PowerShell (as Administrator)

# Enable WSL feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine feature (WSL2 only)
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart Windows
Restart-Computer
```

**Install WSL2 Kernel** (WSL2 only):
```powershell
# Download and install WSL2 kernel update
# https://aka.ms/wsl2kernel

# Or via Windows Update
wsl --update
```

**Set WSL2 as default**:
```powershell
wsl --set-default-version 2
```

### Install Linux Distribution

**From Microsoft Store** (recommended):
1. Open Microsoft Store
2. Search for "Ubuntu", "Debian", "Fedora", or "Arch"
3. Click "Get" and install
4. Launch and create user account

**Or via PowerShell**:
```powershell
# List available distributions
wsl --list --online

# Install distribution
wsl --install -d Ubuntu-22.04
```

### Initial Setup

```bash
# Update package manager
sudo apt update && sudo apt upgrade  # Ubuntu/Debian
sudo dnf update                       # Fedora
sudo pacman -Syu                      # Arch

# Install build tools
sudo apt install -y build-essential git curl  # Ubuntu/Debian
sudo dnf groupinstall -y "Development Tools"  # Fedora
sudo pacman -S base-devel git curl            # Arch
```

## WSL1 vs WSL2

### Differences

| Feature | WSL1 | WSL2 |
|---------|------|------|
| Architecture | Translation layer | Real Linux kernel |
| Performance (file I/O) | Fast on Windows FS | Fast on Linux FS |
| Performance (general) | Good | Better |
| systemd Support | ❌ No | ✅ Yes (WSL 0.67.6+) |
| Docker Support | ❌ Limited | ✅ Full |
| Memory Usage | Lower | Higher (dynamic) |
| Network | Direct Windows network | Virtualized network |

### Check WSL Version

```powershell
# Windows PowerShell
wsl --list --verbose

# Output example:
#   NAME      STATE           VERSION
# * Ubuntu    Running         2
```

### Convert Between Versions

```powershell
# WSL1 to WSL2
wsl --set-version Ubuntu 2

# WSL2 to WSL1
wsl --set-version Ubuntu 1
```

## Installation

### Quick Install

```bash
# Inside WSL
bash <(curl -L https://raw.githubusercontent.com/jrock2004/dotfiles/main/scripts/curl-install.sh)
```

### Local Install

```bash
# Clone repository
git clone https://github.com/jrock2004/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Non-interactive installation (recommended for WSL)
./install.sh --non-interactive

# Or interactive
./install.sh
```

### Selective Installation

```bash
# Minimal setup
./install.sh --only shell,stow

# Development setup
./install.sh --only shell,neovim,tmux,volta,stow

# Skip desktop environment components
./install.sh --skip macos-defaults
```

## WSL Configuration

### Enable systemd (WSL2 Only)

**Automatic** (via dotfiles installer):
```bash
./install.sh
# systemd is enabled automatically on WSL2
```

**Manual**:
```bash
# Create/edit /etc/wsl.conf
sudo tee /etc/wsl.conf <<EOF
[boot]
systemd=true
EOF

# Restart WSL from Windows PowerShell
wsl --shutdown
# Reopen WSL

# Verify systemd is running
systemctl --version
```

### WSL Configuration File

**Location**: `/etc/wsl.conf`

**Example configuration**:
```bash
sudo tee /etc/wsl.conf <<EOF
# Boot settings
[boot]
systemd=true

# Network settings
[network]
generateResolvConf=true
hostname=wsl-ubuntu

# Interop settings
[interop]
enabled=true
appendWindowsPath=true

# User settings
[user]
default=yourusername

# Automount settings
[automount]
enabled=true
root=/mnt/
options="metadata,umask=22,fmask=11"
EOF
```

**Apply changes**:
```powershell
# Windows PowerShell
wsl --shutdown
# Reopen WSL
```

### Windows Configuration (.wslconfig)

**Location**: `C:\Users\YourUsername\.wslconfig`

**Example configuration** (WSL2 only):
```ini
[wsl2]
# Memory allocation (default: 50% of total RAM)
memory=8GB

# CPU cores (default: all cores)
processors=4

# Swap size
swap=2GB

# Disable swap file
# swap=0

# Network mode (default: NAT)
# networkingMode=mirrored  # Windows 11 22H2+

# DNS tunneling (Windows 11 22H2+)
# dnsTunneling=true

# Kernel parameters
kernelCommandLine=cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1
```

**Apply changes**:
```powershell
# Windows PowerShell
wsl --shutdown
# Reopen WSL
```

## Windows Integration

### Clipboard Integration

**Automatic** (via dotfiles):
- Copy: Uses `clip.exe` (Windows clipboard)
- Paste: Uses Windows clipboard integration

**Manual setup**:
```bash
# Check if clip.exe is available
which clip.exe

# Add to ~/.zshrc (already in dotfiles)
if command -v clip.exe &> /dev/null; then
    alias pbcopy='clip.exe'
fi
```

**Usage**:
```bash
# Copy to Windows clipboard
echo "text" | clip.exe
echo "text" | pbcopy  # Using alias

# Paste from Windows clipboard (in terminal)
# Right-click or Ctrl+Shift+V
```

### Browser Integration

**Automatic** (via dotfiles):
- `BROWSER` environment variable set to Windows browser

**Manual setup**:
```bash
# Add to ~/.zshrc
export BROWSER="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
# Or for Firefox:
# export BROWSER="/mnt/c/Program Files/Mozilla Firefox/firefox.exe"
```

**Usage**:
```bash
# Open URL in Windows browser
$BROWSER https://github.com

# If using xdg-open alias (in dotfiles):
xdg-open https://github.com
```

### File System Access

**Access Windows files from WSL**:
```bash
# Windows drives mounted at /mnt/
cd /mnt/c/Users/YourUsername/Documents
ls /mnt/c/
```

**Access WSL files from Windows**:
```
# File Explorer path
\\wsl$\Ubuntu\home\yourusername

# Or newer Windows builds
\\wsl.localhost\Ubuntu\home\yourusername
```

**Important**: Work on files in WSL file system for best performance!
- ✅ Good: `/home/user/project`
- ❌ Slow: `/mnt/c/Users/user/project`

### Windows Executables

**Call Windows executables from WSL**:
```bash
# PowerShell
powershell.exe Get-Date

# CMD
cmd.exe /c dir

# VS Code (if installed on Windows)
code.exe .

# Windows Terminal
wt.exe
```

**Path integration**:
```bash
# Windows PATH is automatically appended to WSL PATH
# Check Windows executables in PATH:
echo $PATH | tr ':' '\n' | grep -i mnt/c

# Disable if needed (in /etc/wsl.conf):
# [interop]
# appendWindowsPath=false
```

## Performance Optimization

### File System Performance

**Best practices**:
1. **Work in WSL file system** (`/home/user/`), not Windows FS (`/mnt/c/`)
2. **Exclude WSL directories** from Windows Defender
3. **Use WSL2** for better overall performance

**Exclude from Windows Defender**:
```powershell
# Windows PowerShell (as Administrator)

# Exclude WSL file system
Add-MpPreference -ExclusionPath "C:\Users\YourUsername\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc\LocalState\ext4.vhdx"

# Or exclude entire WSL directory
Add-MpPreference -ExclusionPath "%USERPROFILE%\AppData\Local\Packages\"
```

### Memory Management

**WSL2 memory usage** (in `.wslconfig`):
```ini
[wsl2]
# Limit memory (default: 50% of total RAM)
memory=8GB

# Limit swap
swap=2GB

# Reclaim memory aggressively
vmIdleTimeout=60000  # 60 seconds
```

**Reclaim memory manually**:
```bash
# Drop caches
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
```

### Network Performance

**DNS configuration**:
```bash
# If DNS is slow, use custom DNS
# Edit /etc/wsl.conf
sudo tee -a /etc/wsl.conf <<EOF
[network]
generateResolvConf=false
EOF

# Set custom DNS in /etc/resolv.conf
sudo tee /etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# Prevent overwrite
sudo chattr +i /etc/resolv.conf

# Restart WSL
```

### Disk Space

**Compact WSL2 virtual disk**:
```powershell
# Windows PowerShell (as Administrator)

# Shutdown WSL
wsl --shutdown

# Compact disk image
diskpart

# In diskpart:
# select vdisk file="C:\Users\YourUsername\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc\LocalState\ext4.vhdx"
# compact vdisk
# exit
```

## Troubleshooting

### WSL Won't Start

**Issue**: WSL fails to start or hangs

**Solution**:
```powershell
# Windows PowerShell (as Administrator)

# Restart WSL service
Restart-Service LxssManager

# Or restart WSL
wsl --shutdown
wsl

# If still failing, unregister and reinstall
wsl --unregister Ubuntu
# Reinstall from Microsoft Store
```

### systemd Not Working

**Issue**: `systemctl` commands fail

**WSL2 solution**:
```bash
# Enable systemd in /etc/wsl.conf
sudo tee /etc/wsl.conf <<EOF
[boot]
systemd=true
EOF

# Restart WSL
exit  # From WSL
wsl --shutdown  # From PowerShell
wsl  # Restart
```

**WSL1**: systemd not supported, use alternatives:
```bash
# Use service command instead
sudo service docker start  # Instead of systemctl start docker
```

### Network/DNS Issues

**Issue**: Can't resolve hostnames or slow DNS

**Solution**:
```bash
# Method 1: Regenerate /etc/resolv.conf
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "nameserver 8.8.4.4" >> /etc/resolv.conf'

# Method 2: Use custom DNS (permanent)
# Edit /etc/wsl.conf
sudo tee /etc/wsl.conf <<EOF
[network]
generateResolvConf=false
EOF

# Set DNS in /etc/resolv.conf
sudo tee /etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF

# Prevent overwrite
sudo chattr +i /etc/resolv.conf

# Restart WSL
```

### Clock Drift

**Issue**: System time is incorrect

**Solution**:
```bash
# Sync hardware clock
sudo hwclock -s

# Or use ntpdate
sudo apt install ntpdate  # Ubuntu/Debian
sudo ntpdate time.windows.com
```

### Permission Issues

**Issue**: Can't access Windows files or wrong permissions

**Solution**:
```bash
# Fix mount options in /etc/wsl.conf
sudo tee /etc/wsl.conf <<EOF
[automount]
enabled=true
options="metadata,umask=22,fmask=11"
EOF

# Restart WSL
exit
wsl --shutdown
wsl

# Verify
ls -la /mnt/c/
```

### Clipboard Not Working

**Issue**: `clip.exe` not found or not working

**Solution**:
```bash
# Check if Windows PATH is appended
echo $PATH | grep -i mnt/c

# If not, enable in /etc/wsl.conf
sudo tee -a /etc/wsl.conf <<EOF
[interop]
enabled=true
appendWindowsPath=true
EOF

# Restart WSL

# Test clipboard
echo "test" | clip.exe
```

### Slow File System Performance

**Issue**: File operations are slow

**Solution**:
1. **Work in WSL file system**, not `/mnt/c/`:
   ```bash
   # Good (fast)
   cd ~/projects

   # Bad (slow)
   cd /mnt/c/Users/YourUsername/projects
   ```

2. **Move projects to WSL**:
   ```bash
   cp -r /mnt/c/Users/YourUsername/project ~/project
   ```

3. **Exclude from Windows Defender** (see [Performance Optimization](#performance-optimization))

### WSL2 Memory Usage

**Issue**: WSL2 using too much RAM

**Solution**:
```ini
# Create/edit C:\Users\YourUsername\.wslconfig
[wsl2]
memory=4GB  # Limit memory
swap=1GB    # Limit swap
```

**Reclaim memory**:
```bash
# Drop caches
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
```

## Tips and Tricks

### Windows Terminal Integration

**Install Windows Terminal**:
```powershell
# From Microsoft Store or via winget
winget install Microsoft.WindowsTerminal
```

**Set WSL as default**:
1. Open Windows Terminal
2. Settings → Startup → Default profile → Ubuntu (or your distro)

**Custom color scheme**: Edit settings.json in Windows Terminal

### VS Code Integration

**Install VS Code with WSL extension**:
```bash
# From WSL, install VS Code extension
code .

# This installs VS Code Server and integrates with Windows VS Code
```

**Open WSL project in VS Code**:
```bash
cd ~/project
code .
```

### Docker Desktop Integration

**Install Docker Desktop** on Windows with WSL2 backend:

1. Install Docker Desktop for Windows
2. Settings → General → Use WSL2 based engine
3. Settings → Resources → WSL Integration → Enable for your distro

**Use Docker from WSL**:
```bash
docker --version
docker run hello-world
```

### Git Configuration

**Git credential helper** (use Windows credentials):
```bash
# Use Windows Git Credential Manager
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
```

**Line endings**:
```bash
# Set line endings for cross-platform work
git config --global core.autocrlf input
git config --global core.eol lf
```

### SSH Agent Forwarding

**Use Windows SSH agent from WSL**:
```bash
# Install npiperelay and socat
sudo apt install socat  # Ubuntu/Debian

# Download npiperelay (Windows)
# https://github.com/jstarks/npiperelay

# Add to ~/.zshrc
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
ss -a | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/path/to/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi
```

### Accessing localhost

**WSL2 networking**:
```bash
# Access Windows localhost from WSL2
# Windows localhost is NOT 127.0.0.1 in WSL2

# Get Windows IP
cat /etc/resolv.conf | grep nameserver | awk '{print $2}'

# Or use hostname
export WINDOWS_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')

# Access Windows service
curl http://$WINDOWS_HOST:8080
```

**Access WSL from Windows**:
```
# Use WSL hostname (Windows 11)
http://localhost:8080

# Or WSL IP
wsl hostname -I
```

### Backup and Restore

**Export WSL distribution**:
```powershell
# Windows PowerShell
wsl --export Ubuntu C:\backup\ubuntu-backup.tar
```

**Import WSL distribution**:
```powershell
# Windows PowerShell
wsl --import Ubuntu C:\WSL\Ubuntu C:\backup\ubuntu-backup.tar
```

### Update WSL

```powershell
# Windows PowerShell
wsl --update

# Check version
wsl --version
```

---

For more information:
- [Main README](../README.md)
- [General Documentation](../CLAUDE.md)
- [macOS Documentation](MACOS.md)
- [Linux Documentation](LINUX.md)
- [Official WSL Documentation](https://learn.microsoft.com/en-us/windows/wsl/)
