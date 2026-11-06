# Windows installer: apps via winget, plus git / WezTerm / VS Code setup.
#
# Fresh machine (nothing installed yet):
#   irm https://raw.githubusercontent.com/jrock2004/dotfiles/main/windows/install.ps1 | iex
#
# From a checkout:
#   powershell -ExecutionPolicy Bypass -File windows\install.ps1
#
# Set $env:DOTFILES_DRYRUN = '1' first to print what would happen without doing it.
# Safe to re-run: winget upgrades apps that are already installed, or leaves them alone.
#
# Runs on Windows PowerShell 5.1 (what a fresh Windows 11 ships with). Keep it ASCII-only:
# 5.1 reads a BOM-less script as ANSI. No param() block: it breaks `irm | iex`.

###########################################
# VARIABLES
###########################################

$DOTFILES = Join-Path $HOME '.dotfiles'
$REPO_URL = 'https://github.com/jrock2004/dotfiles.git'
$DRYRUN = $env:DOTFILES_DRYRUN -eq '1'

# winget exit codes that mean "nothing to do", not failure
$WINGET_ALREADY_INSTALLED = @(-1978335189, -1978335135)

###########################################
# HELPER FUNCTIONS
###########################################

function Write-Step($title) {
    Write-Host ''
    Write-Host '---------------------------------------------------------------------------'
    Write-Host $title -ForegroundColor Cyan
    Write-Host '---------------------------------------------------------------------------'
}

# Pick up PATH changes from installers without opening a new terminal.
function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

function Test-Command($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

# Copy a repo file into $HOME, backing up a different existing file first.
# Copied rather than symlinked: Windows symlinks need Developer Mode or admin.
function Copy-Dotfile($source, $target) {
    if ((Test-Path $target) -and ((Get-FileHash $source).Hash -eq (Get-FileHash $target).Hash)) {
        Write-Host "unchanged: $target"
        return
    }
    if ($DRYRUN) { Write-Host "[dry run] copy $source -> $target"; return }

    New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
    if (Test-Path $target) {
        $backup = "$target.bak"
        Copy-Item $target $backup -Force
        Write-Host "backed up: $target -> $backup"
    }
    Copy-Item $source $target -Force
    Write-Host "copied: $target"
}

# winget.txt -> ordered map of group name -> list of IDs
function Read-AppGroups($path) {
    $groups = [ordered]@{}
    $current = $null
    foreach ($raw in Get-Content $path) {
        $line = ($raw -replace '#.*$', '').Trim()
        if (-not $line) { continue }
        if ($line -match '^\[(.+)\]$') {
            $current = $Matches[1]
            $groups[$current] = New-Object System.Collections.ArrayList
        }
        elseif ($current) {
            [void]$groups[$current].Add($line)
        }
    }
    return $groups
}

function Install-WingetPackage($id) {
    if ($DRYRUN) { Write-Host "[dry run] winget install $id"; return $true }

    # Out-Host so winget's output is shown, not returned along with the result
    winget install --id $id --exact --source winget --silent `
        --accept-package-agreements --accept-source-agreements | Out-Host
    return ($LASTEXITCODE -eq 0 -or $WINGET_ALREADY_INSTALLED -contains $LASTEXITCODE)
}

###########################################
# STEP FUNCTIONS
###########################################

function Test-Winget {
    if (Test-Command 'winget') { return }

    # throw, not exit: under `irm | iex`, exit would close the user's terminal
    throw 'winget is not available yet. Open the Microsoft Store, update "App Installer", then run this again.'
}

# Running from `irm | iex` there is no checkout, so install git and clone one.
function Get-Dotfiles {
    if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot 'winget.txt'))) {
        return (Split-Path $PSScriptRoot)
    }

    if (Test-Path (Join-Path $DOTFILES 'windows\winget.txt')) {
        return $DOTFILES
    }

    Write-Step 'Cloning dotfiles'
    if (-not (Test-Command 'git')) {
        if (-not (Install-WingetPackage 'Git.Git')) { throw 'Could not install git' }
        Update-SessionPath
    }
    if ($DRYRUN) { throw "[dry run] would clone $REPO_URL to $DOTFILES; run from a checkout to dry-run" }

    git clone $REPO_URL $DOTFILES
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
    return $DOTFILES
}

function Select-AppGroups($groups) {
    Write-Step 'Which apps should we install?'

    $names = @($groups.Keys)
    for ($i = 0; $i -lt $names.Count; $i++) {
        $ids = $groups[$names[$i]] -join ', '
        Write-Host ("[{0}] {1,-12} {2}" -f ($i + 1), $names[$i], $ids)
    }
    Write-Host ''
    $answer = "$(Read-Host 'Groups to install, e.g. 1,3,6 (Enter = all, n = none)')".Trim()

    if (-not $answer) { return $names }
    if ($answer -eq 'n') { return @() }

    $picked = @()
    foreach ($part in $answer -split '[,\s]+') {
        $n = 0
        if ([int]::TryParse($part, [ref]$n) -and $n -ge 1 -and $n -le $names.Count) {
            $picked += $names[$n - 1]
        }
        elseif ($part) {
            Write-Host "ignoring '$part'" -ForegroundColor Yellow
        }
    }
    return $picked
}

function Install-Apps($groups, $picked) {
    $failed = @()
    foreach ($name in $picked) {
        Write-Step "Installing $name apps"
        foreach ($id in $groups[$name]) {
            Write-Host "`n=== $id"
            if (-not (Install-WingetPackage $id)) { $failed += $id }
        }
    }
    Update-SessionPath
    return $failed
}

# files/.gitconfig ships the macOS credential.helper (osxkeychain). Reset the helper
# list and use Git Credential Manager, which Git for Windows installs.
function Set-GitConfig($root) {
    Write-Step 'Setting up git config'

    Copy-Dotfile (Join-Path $root 'files\.gitconfig') (Join-Path $HOME '.gitconfig')

    $local = Join-Path $HOME '.gitconfig.local'
    $content = "[credential]`n`thelper =`n`thelper = manager`n"
    if ($DRYRUN) { Write-Host "[dry run] write $local"; return }
    [IO.File]::WriteAllText($local, $content, (New-Object Text.UTF8Encoding $false))
    Write-Host "wrote: $local"
}

function Set-WezTerm($root) {
    Write-Step 'Setting up WezTerm config'

    # WezTerm on Windows reads %USERPROFILE%\.config\wezterm\wezterm.lua
    Copy-Dotfile (Join-Path $root 'files\.config\wezterm\wezterm.lua') `
        (Join-Path $HOME '.config\wezterm\wezterm.lua')
}

function Install-VSCodeExtensions($root) {
    Write-Step 'Installing VS Code extensions'

    if (-not (Test-Command 'code')) {
        Write-Host 'code is not in PATH so extensions are not installed'
        return
    }
    foreach ($ext in Get-Content (Join-Path $root 'scripts\vscode-extensions.txt')) {
        $ext = $ext.Trim()
        if (-not $ext) { continue }
        if ($DRYRUN) { Write-Host "[dry run] code --install-extension $ext"; continue }
        code --install-extension $ext
    }
}

function Set-Directories {
    $dev = Join-Path $HOME 'Development'
    if ($DRYRUN) { Write-Host "[dry run] mkdir $dev"; return }
    New-Item -ItemType Directory -Force $dev | Out-Null
}

function Write-ManualSteps($failed) {
    Write-Step 'Done'

    if ($failed) {
        Write-Host 'These did not install - try them by hand:' -ForegroundColor Yellow
        $failed | ForEach-Object { Write-Host "  $_" }
        Write-Host ''
    }

    Write-Host @'
Not on winget - install these yourself:
  - GPU driver app ........... NVIDIA App (nvidia.com) / AMD Software (amd.com)
  - Chipset + board drivers .. amd.com / your motherboard's support page
  - SSD tool ................. Samsung Magician (semiconductor.samsung.com)
  - Path of Exile (PoE1) ..... pathofexile.com, or through Steam
  - Path of Building (PoE2) .. github.com/PathOfBuildingCommunity/PathOfBuilding-PoE2/releases
  - Exiled Exchange 2 ........ github.com/Kvan7/Exiled-Exchange-2/releases
  - Fonts for WezTerm ........ Geist Mono (vercel.com/font); WezTerm falls back to its built-in font
'@
}

###########################################
# INIT OF APPLICATION
###########################################

# Inside a function so $ErrorActionPreference doesn't leak into the user's
# session when this runs through `irm | iex`.
function Invoke-DotfilesInstall {
    $ErrorActionPreference = 'Stop'

    if ($DRYRUN) { Write-Host 'DRY RUN - nothing will be installed or written' -ForegroundColor Yellow }

    Test-Winget
    $root = Get-Dotfiles
    $groups = Read-AppGroups (Join-Path $root 'windows\winget.txt')
    $picked = Select-AppGroups $groups
    $failed = Install-Apps $groups $picked

    $answer = "$(Read-Host "`nSet up git config, WezTerm config and VS Code extensions? [Y/n]")".Trim()
    if ($answer -notmatch '^n') {
        Set-Directories
        Set-GitConfig $root
        Set-WezTerm $root
        Install-VSCodeExtensions $root
    }

    Write-ManualSteps $failed
}

Invoke-DotfilesInstall
