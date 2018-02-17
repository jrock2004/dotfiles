#!/bin/sh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug 'zsh-users/zsh-autosuggestions'
zplug 'akoenig/npm-run.plugin.zsh'
zplug "docker/compose", use:contrib/completion/zsh

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load
