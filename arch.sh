#!/usr/bin/env bash

sudo pacman -S discord virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq 

# Need to figure out markdown

yay -S ack alacritty bat bluez bluez-utils cloc cmake diff-so-fancy fd fzf gcc github-cli gnupg go google-chrome grep htop jq lazygit luarocks make mpris-proxy-service neofetch neovim noto-fonts-emoji ninja nitrogen openssh python python-pip ripgrep shellcheck slack-desktop spotify starship stow stylua tmux tree vim wget xclip xsel xterm z zsh

pip install git+https://github.com/psf/black

echo -e "Are we installing a Windows Manager? \n\n"

USINGWM=false

select isWM in yes no; do
  case $isWM in
    yes)
      USINGWM=true

      yay -S chrome-gnome-shell orchis-theme-git tela-icon-theme

      break ;;
    no)
      break ;;
    *)
      error "Invalid option $REPLY"
  esac
done

if [ "$USINGWM" == false ]; then
  yay -S dmenu gpicview pcmanfm polybar picom pulseaudio-bluetooth xautolock xmonad xmonad-contrib xmobar xorg-xmessage
fi

echo -e "Do we still want to install a tiling manager? \n\n"

select isTM in yes no; do
  case $isTM in
    yes)
      yay -S dmenu gpicview polybar picom slock xmonad xmonad-contrib xmobar xautolock xorg-xmessage

      break ;;
    no)
      break ;;
    *)
      error "Invalid option $REPLY"
  esac
done
