#!/usr/bin/env bash

selected=$(cat "$DOTFILES/zsh/.tmux-cht-languages" "$DOTFILES/zsh/.tmux-cht-command" | fzf)
read -rp "Enter Query: " query

if grep -qs "$selected" "$DOTFILES/zsh/.tmux-cht-languages"; then
    query=$(echo "$query" | tr ' ' '+')
    echo "curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
    tmux neww bash -c "curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    echo "curl cht.sh/$selected~$query & while [ : ]; do sleep 1; done"
    tmux neww bash -c "curl cht.sh/$selected~$query & while [ : ]; do sleep 1; done"
fi
