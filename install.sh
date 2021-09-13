#!/usr/bin/env bash

# Variables

DOTFILES="$(pwd)"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

# Helper functions
title() {
  echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
  echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
  echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
  # exit 1
}

warning() {
  echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
  echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
  echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

setup_init() {
  title "Checking some things before we start"

  SUCCESS=true

  if [ -z "$(command -v git)" ]; then
    error "Git is not installed, please install before starting"
    SUCCESS=false
  else
    info "Git is installed"
  fi

  # if one of the missing commands is missing, fail the script
  [ "$SUCCESS" = false ] && exit 1

  success "Your system meets the requirements"
}

setup_directories() {
  title "Creating directories you use"

  mkdir -p "$HOME/Development"

  if [ ! -d "$HOME/Development" ]; then
    error "Could not find the Dev"

    exit 1
  fi

  success "Directories created successfully"
}

setup_homebrew() {
  title "Setting up Homebrew"

  if [ -z "$(command -v brew)" ]; then
    info "Homebrew is not installed. Installing"

    sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login

    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  if [ "$(command -v brew)" ]; then
    info "installing software"
    brew bundle
  else
    error "Brew command was not found"
    exit 1
  fi

  if ! [ "$(command -v stow)" ]; then
    error "Stow could not be found"
    exit 1
  fi

  success "Homebrew setup successfully"
}

setup_fzf() {
  title "Setting up FZF"

  if [ "$(command -v brew)" ]; then
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
  else
    error "Something went wrong with setting up FZF"
    exit 1
  fi

  success "FZF setup successfully"
}

setup_stow() {
  title "Linking your files with GNU stow"

  if [ "$(command -v brew)" ]; then
    "$(brew --prefix)"/bin/stow --stow --ignore ".DS_Store" --target="$HOME" --dir="$DOTFILES" files
  fi

  if test ! -f "$HOME/.tmux.conf"; then
    error "Stow did not work"
    exit 1
  fi

  success "Stow setup successfully"
}

setup_zolta() {
  title "Setting up Zolta to manage node and its dependencies"

  curl https://get.volta.sh | bash -s -- --skip-setup

  # For now volta needs this for node and stuff to work
  if [ "$OS" = "Darwin" ]; then
    softwareupdate --install-rosetta
  fi

  if [ "$(command -v volta)" ]; then
    info "Installing some global Node NPM Apps"

    volta install node@lts yarn
  fi

  success "Zolta is setup successfully"
}

setup_lua() {
  title "Setting up lua language server"

  git clone https://github.com/sumneko/lua-language-server "$HOME/lua-language-server"
  cd "$HOME/lua-language-server" || exit 1
  git submodule update --init --recursive
  cd 3rd/luamake || exit 1
  compile/install.sh
  cd ../..
  ./3rd/luamake/luamake rebuild

  cd "$DOTFILES" || exit 1

  luarocks install --server=https://luarocks.org/dev luaformatter

  success "Setup Lua language server successfully"
}

case "$1" in
  directories)
    setup_directories
    ;;
  fzf)
    setup_fzf
    ;;
  homebrew)
    setup_homebrew
    ;;
  init)
    setup_init
    ;;
  lua)
    setup_lua
    ;;
  stow)
    setup_stow
    ;;
  volta)
    setup_volta
    ;;
  *)
    echo -e $"\nUsage: $(basename "$0") {directories|fzf|homebrew|init|lua|stow|volta}\n"
    exit 1
    ;;
esac
