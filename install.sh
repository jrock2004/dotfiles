#!/bin/bash

set -euo pipefail

###########################################
# VARIABLES
###########################################

DOTFILES="$HOME/.dotfiles"
OS=""

###########################################
# HELPER FUNCTIONS
###########################################

lowercase() {
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

printBottomBorder() {
    echo "---------------------------------------------------------------------------"
}

printTopBorder() {
    printf "\n---------------------------------------------------------------------------\n"
}

###########################################
# STEP FUNCTIONS
###########################################

initialQuestions() {
    cat docs/title.txt

    printTopBorder
    echo "Going to ask some questions to make setting up your new machine easier"
    printBottomBorder

    printf "\n"
    echo "What OS are we setting up today?"
    read -rp "[1] Mac OSX  [2] Omarchy / Arch  (default: exit) : " choice_os

    case $choice_os in
    1)
        OS="mac"
        ;;
    2)
        OS="omarchy"
        ;;
    *)
        echo "Invalid choice."

        exit 1
        ;;
    esac
}

setupDirectories() {
    printTopBorder
    echo "Creating some directories"
    printBottomBorder

    mkdir -p "$HOME/Development"
    mkdir -p "$HOME/.tmux/plugins"
}

setupFzf() {
    printTopBorder
    echo "Setting up FZF"
    printBottomBorder

    if [ -x "$(command -v brew)" ]; then
        "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    fi
}

setupNeovim() {
    printTopBorder
    echo "Setting up neovim dependencies"
    printBottomBorder

    if [ "$(command -v python3)" ]; then
        python3 -m pip install --upgrade pynvim
    fi
}

setupRust() {
    printTopBorder
    echo "Setting up rust"
    printBottomBorder

    curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
}

setupShell() {
    printTopBorder
    echo "Switching SHELL to zsh"
    printBottomBorder

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"

    if ! grep "$zsh_path" /etc/shells; then
        echo "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        echo "default shell changed to $zsh_path"
    fi
}

setupStow() {
    printTopBorder
    echo "Using stow to manage symlinking dotfiles"
    printBottomBorder

    if [ "$CI" == true ]; then
        # Some things to do when running via CI
        rm -Rf ~/.gitconfig
    fi

    rm -Rf ~/.zshrc
    rm -Rf ~/.zprofile
    rm -Rf ~/.zshenv

    if [ "$(command -v brew)" ]; then
        "$(brew --prefix)"/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
    elif [ "$(command -v stow)" ]; then
        /usr/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
    fi
}

setupTmux() {
    printTopBorder
    echo "Setting up tmux plugin manager"
    printBottomBorder

    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

setupVolta() {
    printTopBorder
    echo "Going to use Volta for managing node versions"
    printBottomBorder

    curl https://get.volta.sh | bash -s -- --skip-setup

    # For now volta needs this for node and stuff to work
    if [ "$OS" = "mac" ]; then
        softwareupdate --install-rosetta
    fi

    "$HOME"/.volta/bin/volta install node@lts yarn@1.22.19 pnpm
}

setupClaudeCli() {
    printTopBorder
    echo "Installing Claude Code CLI"
    printBottomBorder

    curl -fsSL https://claude.ai/install.sh | bash
}

setupCursorCli() {
    printTopBorder
    echo "Installing Cursor CLI"
    printBottomBorder

    curl https://cursor.com/install -fsS | bash
}

setupForMac() {
    printTopBorder
    echo "Installing apps for Mac"
    printBottomBorder

    if [ -z "$(command -v brew)" ]; then
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

        echo "eval '$(/opt/homebrew/bin/brew shellenv)'" >>"$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    brew bundle

    if [ -x "$(command -v code)" ]; then
        echo "Installing Visual Studio Code extensions"

        cat ./scripts/vscode-extensions.txt | xargs -L1 code --install-extension
    else
        echo "Code is not in path so extensions are not installed"
    fi

    setupDirectories
    setupClaudeCli
    setupCursorCli
    setupFzf
    setupNeovim
    setupRust
    setupStow
    setupShell
    setupTmux
    setupVolta

    # disables the hold key menu to allow key repeat
    defaults write -g ApplePressAndHoldEnabled -bool false

    # The speed of repetition of characters
    defaults write -g KeyRepeat -int 2

    # Delay until repeat
    defaults write -g InitialKeyRepeat -int 15
}

###########################################
# OMARCHY / ARCH STEP FUNCTIONS
###########################################

# files/.gitconfig ships the macOS credential.helper (osxkeychain). On other
# platforms that binary does not exist, so write a ~/.gitconfig.local that
# resets the helper list (empty `helper =`) and points at libsecret instead.
# macOS needs nothing here - the committed default already works.
setupGitLocal() {
    printTopBorder
    echo "Writing ~/.gitconfig.local"
    printBottomBorder

    cat >"$HOME/.gitconfig.local" <<'EOF'
[credential]
	helper =
	helper = /usr/lib/git-core/git-credential-libsecret
EOF
}

setupOmarchyPackages() {
    printTopBorder
    echo "Installing packages via pacman + yay"
    printBottomBorder

    local pac=(
        stow tmux zsh
        stylua shellcheck
        zellij tree wget gnupg chafa
        fd ripgrep eza bat jq fzf lazygit
        ast-grep cmake ninja cloc htop highlight vim
    )

    sudo pacman -S --needed "${pac[@]}"

    if [ -x "$(command -v yay)" ]; then
        yay -S --needed diff-so-fancy prettier markdownlint-cli2 viu || true
    fi
}

setupVSCode() {
    printTopBorder
    echo "Installing VS Code + extensions"
    printBottomBorder

    if [ -x "$(command -v yay)" ]; then
        yay -S --needed visual-studio-code-bin || true
    fi

    if [ -x "$(command -v code)" ]; then
        xargs -L1 code --install-extension <./scripts/vscode-extensions.txt || true
    else
        echo "code not in PATH; skipping extensions"
    fi
}

# Desktop apps mirrored from the macOS Brewfile casks. pacman where available,
# AUR (yay) otherwise. Comment out anything you do not want.
setupOmarchyApps() {
    printTopBorder
    echo "Installing desktop apps"
    printBottomBorder

    sudo pacman -S --needed discord wezterm

    if [ -x "$(command -v yay)" ]; then
        yay -S --needed \
            brave-bin google-chrome \
            slack-desktop \
            postman-bin notion-app-electron || true
    fi
}

setupMiseTools() {
    printTopBorder
    echo "Installing language runtimes via mise"
    printBottomBorder

    if [ -x "$(command -v mise)" ]; then
        mise use -g pnpm@latest || true
        mise use -g go@latest || true
        mise use -g rust@latest || true
    else
        echo "mise not found; skipping runtime setup"
    fi
}

# Stow a Omarchy-safe subset: keep Omarchy's own nvim/ghostty/lazygit configs
# and skip the macOS-only zsh dotfiles. Our nvim config is linked side-by-side
# as ~/.config/ownnvim (launch with `vim2` / NVIM_APPNAME=ownnvim).
setupStowOmarchy() {
    printTopBorder
    echo "Symlinking dotfiles with stow (Omarchy-safe subset)"
    printBottomBorder

    # First pattern (bare, no anchors): matched against each path segment, so
    # "nvim" skips the whole .config/nvim subtree. Second (anchored): whole
    # basenames. nvim/ghostty/lazygit/.tmux.conf: Omarchy ships its own.
    stow --ignore='(nvim|ghostty|lazygit)' \
        --ignore='^\.(zshrc|zprofile|zshenv|p10k\.zsh|tmux\.conf)$' \
        --ignore='\.DS_Store' \
        -v -R -t ~ -d "$DOTFILES" files

    mkdir -p "$HOME/.config"
    ln -sfn "$DOTFILES/files/.config/nvim" "$HOME/.config/ownnvim"
}

setupBashrcOmarchy() {
    printTopBorder
    echo "Wiring dotfiles into ~/.bashrc"
    printBottomBorder

    local marker="bash/omarchy.bash"
    local line='[ -f "$HOME/.dotfiles/bash/omarchy.bash" ] && source "$HOME/.dotfiles/bash/omarchy.bash"'

    if grep -qF "$marker" "$HOME/.bashrc" 2>/dev/null; then
        echo "~/.bashrc already sources dotfiles"
    else
        printf '\n# Load dotfiles bash config\n%s\n' "$line" >>"$HOME/.bashrc"
        echo "added source line to ~/.bashrc"
    fi
}

setupForOmarchy() {
    printTopBorder
    echo "Setting up Omarchy"
    printBottomBorder

    setupDirectories
    setupOmarchyPackages
    setupMiseTools
    setupCursorCli
    setupVSCode
    setupOmarchyApps
    setupGitLocal
    setupStowOmarchy
    setupBashrcOmarchy

    printTopBorder
    echo "Done. Open a new terminal or run: source ~/.bashrc"
    echo "Default 'nvim' stays Omarchy's. Your config: 'vim2' (NVIM_APPNAME=ownnvim)."
    printBottomBorder
}

###########################################
# INIT OF APPLICATION
###########################################

initialQuestions

if [ "$OS" = "mac" ]; then
    setupForMac
elif [ "$OS" = "omarchy" ]; then
    setupForOmarchy
else
    echo "Something went wrong, try again and if it still fails, open an issue on Github"

    exit 1
fi
