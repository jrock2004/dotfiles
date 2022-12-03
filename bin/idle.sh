#!/bin/sh

swayidle \
timeout 300 "$HOME/.dotfiles/bin/lock.sh --grace 10 --fade-in 0" \
timeout 540 'hyprctl dispatch dpms off DP-2' \
resume 'hyprctl dispatch dpms on DP-2' \
before-sleep "$HOME/.dotfiles/bin/lock.sh --fade-in 0"

## template I used

# swayidle -w \
# 	timeout 300 '~/.config/hypr/lock.sh' \
# 	timeout 360 'hyprctl dispatch dpms off eDP-1 && hyprctl dispatch dpms off DP-1' \
# 	resume '
# 		hyprctl monitors | grep HDMI
# 		ret=$?
# 		if [ $ret -eq 0 ]	
# 		then
# 			hyprctl dispatch dpms on DP-1
# 		else
# 			hyprctl dispatch dpms on eDP-1
# 		fi
# 		' \
# 	before-sleep '~/.config/hypr/lock.sh' \
# 	lock '~/.config/hypr/lock.sh'
