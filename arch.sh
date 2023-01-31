#!/usr/bin/env bash

# Need to figure out markdown

paru -S 1password ack alacritty bat bluez bluez-utils cava cloc cmake diff-so-fancy discord dnsmasq edk2-ovmf fd fzf gcc github-cli gnupg go google-chrome grep htop isync jq kitty lazygit libvirt luarocks lynx make mpris-proxy-service msmtp mutt-wizard-git neofetch neomutt neovim noto-fonts-emoji ninja nitrogen openssh pam-gnupg pass python python-pip qemu-desktop ripgrep scrot shellcheck slack-desktop spotify starship stow stylua swtpm tmux ttf-inconsolata ttf-linux-libertine ttf-symbola urlview viewnior vim virt-manager xclip xsel xterm z zsh

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
      paru -S catppuccin-gtk-theme-mocha catppuccin-cursors-mocha catppuccin-mocha-grub-theme-git colord cronie dmenu dunst ffmpegthumbnailer file-roller gpicview grim grimblast-git hyprland-git hyprpicker-git hyprpaper-git imagemagick nwg-look-bin otf-font-awesome pavucontrol pcmanfm polybar picom rofi-lbonn-wayland-git rofi-emoji sddm slock slurp-git swappy swaybg swayidle-git swaylock-effects-git thunar thunar-archive-plugin tumbler waybar-hyprland-git wezterm wf-recorder wl-clipboard wlogout wtype xautolock xmonad xdg-desktop-portal-hyprland-git xmonad-contrib xorg-xmessage

      sudo systemctl enable cronie.service
      sudo systemctl enable sddm.service

      sudo cp archfiles/slock@.service /etc/systemd/system/

      sudo systemctl enable slock@jcostanzo.service

      break ;;
    *)
      error "Invalid option $REPLY"
  esac
done

if [ "$USINGWM" == "true" ]; then
  echo -e "Do we still want to install a tiling manager? \n\n"

  select isTM in yes no; do
    case $isTM in
      yes)
        paru -S dmenu polybar picom slock xmonad xmonad-contrib xautolock xorg-xmessage
      break ;;
    no)
      break ;;
    *)
      error "Invalid option $REPLY"
  esac
done
fi

# Copy bluetooth keyboard rule
[ -d "/etc/udev/rules.d" ] && sudo cp archfiles/91-keyboard-mouse-wakeup.conf /etc/udev/rules.d/

# Setup my Suckless st terminal
git clone https://github.com/jrock2004/st.git
cd "st" || echo "Something went wrong with st setup"
makepkg -si
cd "../"
rm -Rf "st"
