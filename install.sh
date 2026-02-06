#!/bin/bash

###########################################
# VARIABLES
###########################################

DOTFILES="$HOME/.dotfiles"
OS=""
USE_DESKTOP_ENV=FALSE

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
    read -rp "[1] Mac OSX (default: exit) : " choice_os

    case $choice_os in
    1)
        OS="mac"
        ;;
    *)
        echo "Invalid choice."

        exit 1
        ;;
    esac

    printf "\n"

    echo "Do you have a desktop environment?"
    read -rp "[y]es or [n]o (default: no) : " choice_desktop

    case $choice_desktop in
    y)
        USE_DESKTOP_ENV=TRUE
        ;;
    n)
        USE_DESKTOP_ENV=FALSE
        ;;
    *)
        USE_DESKTOP_ENV=FALSE
        ;;
    esac

    echo "$USE_DESKTOP_ENV"
}

setupDirectories() {
    printTopBorder
    echo "Creating some directories"
    printBottomBorder

    mkdir -p "$HOME/Development"
    mkdir -p "$HOME/.tmux/plugins"

    # if [ "$USE_DESKTOP_ENV" = FALSE ]; then
    #     mkdir -p "$HOME/Pictures"
    #     mkdir -p "$HOME/Pictures/avatars"
    #     mkdir -p "$HOME/Pictures/wallpapers"
    # fi
}

setupFzf() {
    printTopBorder
    echo "Setting up FZF"
    printBottomBorder

    if [ -x "$(command -v brew)" ]; then
        "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    fi
}

setupLua() {
    printTopBorder
    echo "Setting up Lua"
    printBottomBorder

    git clone https://github.com/sumneko/lua-language-server "$HOME/lua-language-server"
    cd "$HOME/lua-language-server" || exit 1
    git submodule update --init --recursive
    cd 3rd/luamake || exit 1
    compile/install.sh
    cd ../..
    ./3rd/luamake/luamake rebuild

    cd "$DOTFILES" || exit 1

    if [ "$(command -v luarocks)" ]; then
        luarocks install --server=https://luarocks.org/dev luaformatter
    fi
}

setupNeovim() {
    printTopBorder
    echo "Setting up neovim dependencies"
    printBottomBorder

    if [ "$(command -v python)" ]; then
        python -m pip install --upgrade pynvim
    fi
}

setupRust() {
    printTopBorder
    echo "Setting up rust"
    printBottomBorder

    curl https://sh.rustup.rs -sSf | sh
}

setupShell() {
    printTopBorder
    echo "Switching SHELL to zsh"
    printBottomBorder

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"

    if ! grep "$zsh_path" /etc/shells; then
        info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        info "default shell changed to $zsh_path"
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
        rm -Rf ~/.zprofile

        "$(brew --prefix)"/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
    elif [ "$(command -v stow)" ]; then
        /usr/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
    fi
}

setupTmux() {
    printTopBorder
    echo "Setting up tmux plugin manager"
    printBottomBorder

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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

setupForMac() {
    printTopBorder
    echo "Installing apps for Mac"
    printBottomBorder

    if [ -z "$(command -v brew)" ]; then
        sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login

        echo "eval '$(/opt/homebrew/bin/brew shellenv)'" >>/Users/jcostanzo/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    brew bundle

    if [ -x "$(command -v code)" ]; then
        echo "Installing Visual Studio Code extensions"

        cat ./scripts/vscode-extensions.txt | xargs -L1 code --install-extension
    else
        echo "Code is not in path so extensions are not installed"
    fi

    curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v1.0.16/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

    setupDirectories
    setupClaudeCli
    setupFzf
    setupLua
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
# INIT OF APPLICATION
###########################################

initialQuestions

if [ "$OS" = "mac" ]; then
    setupForMac
else
    echo "Something went wrong, try again and if it still fails, open an issue on Github"

    exit 1
fi
