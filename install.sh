#!/bin/bash

###########################################
# VARIABLES
###########################################

OS=""
USE_DESKTOP_ENV=FALSE
ARCH_APPS=()
POP_APPS=()
DOTFILES="$HOME/.dotfiles"

###########################################
# HELPER FuNCTIONS
###########################################

printBottomBorder () {
  echo "---------------------------------------------------------------------------"
}

printTopBorder () {
  printf "\n---------------------------------------------------------------------------\n"
}

initialQuestions () {
  printTopBorder
  echo "Going to ask some questions to make setting up your new machine easier"
  printBottomBorder

  printf "\n"
  echo "What OS are we setting up today?"
  read -rp "[1] Arch or [2] Mac OSX or [3] Pop OS (default: exit) : " choice_os

  case $choice_os in
    1)
      OS="arch"
      ;;
    2)
      OS="mac"
      ;;
    3)
      OS="debian"
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

initForArch () {
  printTopBorder
  echo "Setting up this computer for $OS"
  printBottomBorder

  # Get all the arch apps we are going to install
  mapfile -t ARCH_APPS < archApps.txt

  if [ -z "$(command -v git)" ]; then
    echo "Git is not installed. Installing now..."

    sudo pacman -S git
  fi

  if [ -z "$(command -v curl)" ]; then
    echo "Curl is not installed. Installing now..."

    sudo pacman -S curl
  fi

  if [ -z "$(command -v wget)" ]; then
    echo "Wget is not installed. Installing now..."

    sudo pacman -S wget
  fi

  if [ -z "$(command -v paru)" ]; then
    echo "Paru is not installed. Installing now..."

    git clone https://aur.archlinux.org/paru.git
    cd paru || exit 1
    makepkg -si
    cd ..
    rm -rf paru
  fi
}

initForDebian () {
  printTopBorder
  echo "Setting up this computer for $OS"
  printBottomBorder

  mapfile -t POP_APPS < popApps.txt

  if [ -z "$(command -v git)" ]; then
    echo "Git is not installed. Installing now..."

    sudo apt-get install git
  fi

  if [ -z "$(command -v curl)" ]; then
    echo "Curl is not installed. Installing now..."

    sudo apt-get install curl
  fi

  if [ -z "$(command -v wget)" ]; then
    echo "Wget is not installed. Installing now..."

    sudo apt-get install wget
  fi
}

initForMac () {
  printTopBorder
  echo "Setting up this computer for $OS"
  printBottomBorder

  if [ -z "$(command -v git)" ]; then
    echo "You need to install command line tools"

    sudo xcode-select --install
  fi
}

installAppsForArch () {
  printTopBorder
  echo "Installing apps for arch"
  printBottomBorder

  echo "${ARCH_APPS[@]}" | xargs paru -S

  if [ "$USE_DESKTOP_ENV" = "FALSE" ]; then
    echo "Installing some apps since we do not have a desktop environment"

    paru -S cronie pavucontrol sddm-git

    sudo systemctl enable cronie.service
    sudo systemctl enable sddm.service

    sudo cp archfiles/slock@.service /etc/systemd/system/

    sudo systemctl enable slock@jcostanzo.service

    [ -d "/etc/udev/rules.d" ] && sudo cp archfiles/91-keyboard-mouse-wakeup.conf /etc/udev/rules.d/
  fi
}

installAppsForDebian () {
  printTopBorder
  echo "Installing apps for debian based distro"
  printBottomBorder

  echo "${POP_APPS[@]}" | xargs sudo apt-get install

  # 1Password
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  sudo apt update && sudo apt install 1password

  # Golang
  curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
  sudo tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz
  rm go1.16.7.linux-amd64.tar.gz

  # Starship
  # curl -sS https://starship.rs/install.sh | sh

  # Lazygit
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit.tar.gz
  rm lazygit
  rm -Rf ~/.config/lazygit
}

installAppsForMac () {
  printTopBorder
  echo "Installing apps for Mac"
  printBottomBorder

  if [ -z "$(command -v brew)" ]; then
    sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login

    echo "eval '$(/opt/homebrew/bin/brew shellenv)'" >> /Users/jcostanzo/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  brew bundle
}

setupDirectories () {
  printTopBorder
  echo "Creating some directories"
  printBottomBorder

  mkdir -p "$HOME/Development"

  if [ "$USE_DESKTOP_ENV" = FALSE ]; then
    mkdir -p "$HOME/Pictures"
    mkdir -p "$HOME/Pictures/avatars"
    mkdir -p "$HOME/Pictures/wallpapers"
  fi
}

setupFzf () {
  printTopBorder
  echo "Setting up FZF"
  printBottomBorder

  "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

setupLua () {
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

setupNeovim () {
  printTopBorder
  echo "Setting up neovim dependencies"
  printBottomBorder

  if [ "$OS" = "debian" ]; then
    python3 -m pip install --upgrade pynvim
  elif [ "$OS" = "arch" ]; then
    python3 -m pip install --upgrade pynvim
  elif [ "$(command -v python)" ]; then
    python -m pip install --upgrade pynvim
  fi
}

setupStow () {
  printTopBorder
  echo "Using stow to manage symlinking dotfiles"
  printBottomBorder

  if [ "$CI" == true ]; then
    # Some things to do when running via CI
    rm -Rf ~/.gitconfig
  fi

  rm -Rf ~/.zshrc

  if [ "$(command -v brew)" ]; then
    rm -Rf ~/.zprofile

    "$(brew --prefix)"/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
  elif [ "$(command -v stow)" ]; then
    /usr/bin/stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files
  fi
}

setupRust () {
  printTopBorder
  echo "Setting up rust"
  printBottomBorder

  curl https://sh.rustup.rs -sSf | sh
}

setupShell () {
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

setupVolta () {
  printTopBorder
  echo "Going to use Volta for managing node versions"
  printBottomBorder

  curl https://get.volta.sh | bash -s -- --skip-setup

  # For now volta needs this for node and stuff to work
  if [ "$OS" = "mac" ]; then
    softwareupdate --install-rosetta
  fi

  if [ "$(command -v volta)" ]; then
    volta install node@16 yarn@1.22.19 pnpm
  else
    echo "After restarting the terminal, you will want to volta install node and yarn"
  fi
}

setupZap () {
  printTopBorder
  echo "Setting up Zap for terminal prompt"
  printBottomBorder

  zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh)
}

###########################################
# INIT OF APPLICATION
###########################################

initialQuestions

if [ "$OS" = "arch" ]; then
  initForArch
  installAppsForArch
elif [ "$OS" = "debian" ]; then
  initForDebian
  installAppsForDebian
elif [ "$OS" = "mac" ]; then
  initForMac
  installAppsForMac
else
  echo "Something went wrong, try again and if it still fails, open an issue on Github"

  exit 1
fi

setupDirectories
setupStow
setupVolta
setupLua
setupRust
setupNeovim
setupZap
setupShell

if [ "$OS" = "mac" ]; then
  setupFzf
fi

printTopBorder
echo "Machine is now setup. Restart machine and everything should take effect"
printBottomBorder
