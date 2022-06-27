#!/usr/bin/env bash

###########################################
# VARIABLES
###########################################

DOTFILES="$(pwd)"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"
OS=""
USEBREW=false

###########################################
# HELPER FUNCTIONS
###########################################

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

###########################################
# SETUP SYSTEM
###########################################

setup_prereq() {
  title "Check if $1 has all the required dependencies before starting"

  SUCCESS=true

  if [ -z "$(command -v git)" ]; then
    error "Git is not installed, please install before starting"

    SUCCESS=false
  fi

  if [ "$OS" == "popos" ]; then
    sudo apt-get install build-essential procps curl file
  fi

  if [ "$OS" == "arch" ]; then
    if [ -z "$(command -v paru)" ]; then
      info "You need to install paru before you can run this script"

      git clone https://aur.archlinux.org/paru.git
      cd "paru" || error "Something went wrong" && SUCCESS=false
      makepkg -si
      cd "../"
      rm -Rf "paru"
    fi

    [ "$SUCCESS" = true ] && paru -S base-devel curl
  fi

  # if one of the missing commands is missing, fail the script
  [ "$SUCCESS" = false ] && exit 1

  success "Your $OS meets all the requirements"
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
  fi

  if [ "$(uname)" == "Linux" ]; then
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  fi

  if [ "$(command -v brew)" ]; then
    info "installing software"

    brew bundle
  else
    error "Brew command was not found"

    exit 1
  fi

  if ! [ "$(command -v stow)" ]; then
    error "Something went wrong with homebrew, try again!"

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
  elif [ "$(command -v stow)" ]; then
    /usr/bin/stow --stow --ignore ".DS_Store" --target="$HOME" --dir="$DOTFILES" files
  fi

  if test ! -f "$HOME/.tmux.conf"; then
    error "Stow did not work"
    exit 1
  fi

  success "Stow setup successfully"
}

setup_volta() {
  title "Setting up Zolta to manage node and its dependencies"

  curl https://get.volta.sh | bash -s -- --skip-setup

  # For now volta needs this for node and stuff to work
  if [ "$OS" = "mac" ]; then
    softwareupdate --install-rosetta
  fi

  success "Volta is setup successfully"
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

  if [ "$(command -v luarocks)" ]; then
    luarocks install --server=https://luarocks.org/dev luaformatter
  else
    warning "luarocks is not in path. Need to run command after restart"
  fi

  success "Setup Lua language server successfully"
}

setup_neovim() {
  title "Setting things up for neovim"

  if [ "$OS" = "popos" ]; then
    python3 -m pip install --upgrade pynvim
  elif [ "$OS" = "arch" ]; then
    python3 -m pip install --upgrade pynvim
  elif [ "$(command -v python)" ]; then
    python -m pip install --upgrade pynvim

    success "Neovim is setup successfully"
  else
    warning "Neovim will need pynvim setup after script is done"
  fi

  info "Installing Rust"
  curl https://sh.rustup.rs -sSf | sh

  success "Finished setting up Neovim"
}

setup_shell() {
  title "Configuring shell"

  [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
  if ! grep "$zsh_path" /etc/shells; then
    info "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
  fi

  if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    info "default shell changed to $zsh_path"
  fi

  success "Configuring shell was successfully"
}

###########################################
# INITAL QUESTIONS
###########################################

title "Which OS are we setting up? "

select os in mac popos arch; do
  case $os in
    mac)
      OS="mac"
      break ;;
    popos)
      OS="popos"
      break ;;
    arch)
      OS="arch"
      break ;;
    *)
      error "Invalid option $REPLY"
  esac
done

title "Do you want to use brew? "

select optionBrew in yes no; do
  case $optionBrew in
    yes)
      USEBREW=true

      break ;;
    no)
      USEBREW=false

      break ;;
    *)
      error "Invalid option $REPLY"
  esac
done

###########################################
# RUNNING SET UP
###########################################

# if [ $OS == "mac" ]; then
#   setup_init
#   setup_directories
#   setup_homebrew
#   setup_fzf
#   setup_stow
#   setup_volta
#   setup_lua
#   setup_neovim
# elif [ $OS == "popos" ]; then
#   setup_init
#   setup_directories
#
#   source ./linux.sh # install some things for linux
#
#   if [ $USEBREW == true ]; then
#     setup_homebrew
#   fi
#
#   setup_stow
#   setup_volta
#   setup_lua
#   setup_neovim
# elif [ $OS == "arch" ]; then
#   setup_init
#   setup_directories
#
#   source ./arch.sh # Installing files for arch systems
#
#   setup_stow
#   setup_volta
#   setup_lua
#   setup_neovim
# fi
#
# setup_shell
#
# success "Your system is ready to go. Reboot and read the readme for rest of set up"

exit 0
