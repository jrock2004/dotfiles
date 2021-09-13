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

case "$1" in
  directories)
    setup_directories
    ;;
  homebrew)
    setup_homebrew
    ;;
  init)
    setup_init
    ;;
  *)
    echo -e $"\nUsage: $(basename "$0") {directories|homebrew|init}\n"
    exit 1
    ;;
esac
