#!/usr/bin/env bash

# Need to figure out markdown

paru -S ack alacritty bat bluez bluez-utils cloc cmake diff-so-fancy discord dnsmasq edk2-ovmf fd fzf gcc github-cli gnupg go google-chrome grep htop jq lazygit lobvirt luarocks make mpris-proxy-service neofetch neovim noto-fonts-emoji ninja nitrogen openssh python python-pip qemu-desktop ripgrep shellcheck slack-desktop spotify starship stow stylua tmux tree vim virt-manager xclip xsel xterm z zsh

pip install git+https://github.com/psf/black

echo -e "Are we installing a Windows Manager? \n\n"

USINGWM=false

select isWM in yes no; do
  case $isWM in
    yes)
      USINGWM=true

      paru -S chrome-gnome-shell orchis-theme-git tela-icon-theme

      break ;;
    no)
      break ;;
    *)
      error "Invalid option $REPLY"
  esac
done

if [ "$USINGWM" == false ]; then
  paru -S dmenu gpicview pcmanfm polybar picom xautolock xmonad xmonad-contrib xmobar xorg-xmessage
fi

echo -e "Do we still want to install a tiling manager? \n\n"

select isTM in yes no; do
  case $isTM in
    yes)
      paru -S dmenu gpicview polybar picom slock xmonad xmonad-contrib xmobar xautolock xorg-xmessage

      # Setting up slock to lock screen
      git clone https://git.suckless.org/slock
      cd "slock" || echo "Something went wrong with slock setup"
      makepkg -si
      cd "../"
      rm -Rf "slock"

      break ;;
    no)
      break ;;
    *)
      error "Invalid option $REPLY"
  esac
done

# Copy bluetooth keyboard rule
[ -d "/etc/udev/rules.d" ] && cp archfiles/91-keyboard-mouse-wakeup.conf /etc/udev/rules.d/

