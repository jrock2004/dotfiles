#!/bin/sh

swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f'

# swayidle \
#     timeout 300 "$HOME/.dotfiles/bin/lock.sh --grace 10 --fade-in 0" \
#     timeout 540 'hyprctl dispatch dpms off DP-2' \
#     resume 'hyprctl dispatch dpms on DP-2'
# before-sleep "$HOME/.dotfiles/bin/lock.sh --fade-in 0"
