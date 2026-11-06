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

# Not on winget, but published as GitHub release assets: downloaded to Downloads.
# Pattern picks the installer out of the release's assets.
$GITHUB_INSTALLERS = @(
    @{ Name = 'Path of Building (PoE2)'; Repo = 'PathOfBuildingCommunity/PathOfBuilding-PoE2'; Pattern = 'Setup\.exe$' }
    @{ Name = 'Exiled Exchange 2'; Repo = 'Kvan7/Exiled-Exchange-2'; Pattern = '^Exiled-Exchange-2-Setup-.*\.exe$' }
)

# Not on winget and no stable direct link (versioned URLs, or the site blocks scripted
# downloads): opened in the browser instead.
$DOWNLOAD_PAGES = @(
    @{ Name = 'AMD chipset driver'; Url = 'https://www.amd.com/en/support/download/drivers.html' }
    @{ Name = 'ASUS TUF B650-E WIFI drivers (MediaTek Bluetooth + Wi-Fi, Realtek audio)'; Url = 'https://www.asus.com/us/motherboards-components/motherboards/tuf-gaming/tuf-gaming-b650-e-wifi/helpdesk_download?model2Name=TUF-GAMING-B650-E-WIFI' }
    @{ Name = 'NVIDIA App'; Url = 'https://www.nvidia.com/en-us/software/nvidia-app/' }
    @{ Name = 'Samsung Magician'; Url = 'https://semiconductor.samsung.com/consumer-storage/support/tools/' }
    @{ Name = 'Path of Exile (sign in to see the download)'; Url = 'https://www.pathofexile.com/download' }
)

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

function Get-DownloadsFolder {
    # Resolves a moved/redirected Downloads folder, unlike $HOME\Downloads
    return (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
}

# Downloads installers to the Downloads folder; does not run them.
function Get-GitHubInstallers {
    Write-Step 'Downloading installers that are not on winget'

    # Windows PowerShell 5.1 defaults to TLS 1.0, which GitHub refuses; the progress
    # bar makes Invoke-WebRequest many times slower there.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'

    $downloads = Get-DownloadsFolder
    $failed = @()
    foreach ($app in $GITHUB_INSTALLERS) {
        try {
            $release = Invoke-RestMethod "https://api.github.com/repos/$($app.Repo)/releases/latest" `
                -Headers @{ 'User-Agent' = 'dotfiles-install' }
            $asset = $release.assets | Where-Object { $_.name -match $app.Pattern } | Select-Object -First 1
            if (-not $asset) { throw "no installer matching '$($app.Pattern)' in $($release.tag_name)" }

            $target = Join-Path $downloads $asset.name
            if ($DRYRUN) { Write-Host "[dry run] download $($asset.browser_download_url) -> $target"; continue }

            Invoke-WebRequest $asset.browser_download_url -OutFile $target -UseBasicParsing
            Write-Host "downloaded: $($app.Name) $($release.tag_name) -> $target"
        }
        catch {
            Write-Host "could not download $($app.Name): $($_.Exception.Message)" -ForegroundColor Yellow
            $failed += "$($app.Name) - github.com/$($app.Repo)/releases"
        }
    }
    return $failed
}

function Open-DownloadPages {
    Write-Step 'Opening download pages'

    foreach ($page in $DOWNLOAD_PAGES) {
        Write-Host "$($page.Name): $($page.Url)"
        if (-not $DRYRUN) { Start-Process $page.Url }
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

    Write-Host "Installers downloaded to $(Get-DownloadsFolder) are not run - double-click them."
    Write-Host 'Fonts for WezTerm: Geist Mono (vercel.com/font); until then WezTerm uses its built-in font.'
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

    $answer = "$(Read-Host "`nDownload the installers winget doesn't have, and open the driver download pages? [Y/n]")".Trim()
    if ($answer -notmatch '^n') {
        $failed += Get-GitHubInstallers
        Open-DownloadPages
    }

    Write-ManualSteps $failed
}

Invoke-DotfilesInstall
