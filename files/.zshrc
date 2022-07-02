########################################################
# Variables
########################################################
export DOTFILES=$HOME/.dotfiles
export ZSH=$DOTFILES/scripts/zsh
export VOLTA_HOME=$HOME/.volta

if [[ -d $DOTFILES/zsh/functions ]]; then
  for func in $DOTFILES/zsh/functions/*(:t); autoload -U $func
fi

########################################################
# Configuration
########################################################

COLOR_BLACK="\e[0;30m"
COLOR_BLUE="\e[0;34m"
COLOR_GREEN="\e[0;32m"
COLOR_CYAN="\e[0;36m"
COLOR_PINK="\e[0;35m"
COLOR_RED="\e[0;31m"
COLOR_PURPLE="\e[0;35m"
COLOR_BROWN="\e[0;33m"
COLOR_LIGHTGRAY="\e[0;37m"
COLOR_DARKGRAY="\e[1;30m"
COLOR_LIGHTBLUE="\e[1;34m"
COLOR_LIGHTGREEN="\e[1;32m"
COLOR_LIGHTCYAN="\e[1;36m"
COLOR_LIGHTRED="\e[1;31m"
COLOR_LIGHTPURPLE="\e[1;35m"
COLOR_YELLOW="\e[1;33m"
COLOR_WHITE="\e[1;37m"
COLOR_NONE="\e[0m"

# initialize autocomplete
autoload -U compinit add-zsh-hook
compinit

prepend_path /usr/local/opt/grep/libexec/gnubin
prepend_path /usr/local/sbin
prepend_path $DOTFILES/bin
prepend_path $VOLTA_HOME/bin
prepend_path $HOME/.local/lib/python3.9/site-packages
prepend_path $HOME/.local/bin


if [[ -d /usr/local/go/bin ]]; then
  prepend_path /usr/local/go/bin
fi

export REPORTTIME=10
export KEYTIMEOUT=1              # 10ms delay for key sequences

setopt NO_BG_NICE
setopt NO_HUP                    # don't kill background jobs when the shell exits
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt PROMPT_SUBST

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY          # write the history file in the ":start:elapsed;command" format.
setopt HIST_REDUCE_BLANKS        # remove superfluous blanks before recording entry.
setopt SHARE_HISTORY             # share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS      # delete old recorded entry if new entry is a duplicate.

setopt COMPLETE_ALIASES

bindkey "^[[1;5C" forward-word                      # [Ctrl-right] - forward one word
bindkey "^[[1;5D" backward-word                     # [Ctrl-left] - backward one word
bindkey '^[^[[C' forward-word                       # [Ctrl-right] - forward one word
bindkey '^[^[[D' backward-word                      # [Ctrl-left] - backward one word
bindkey '^[[1;3D' beginning-of-line                 # [Alt-left] - beginning of line
bindkey '^[[1;3C' end-of-line                       # [Alt-right] - end of line
bindkey '^[[5D' beginning-of-line                   # [Alt-left] - beginning of line
bindkey '^[[5C' end-of-line                         # [Alt-right] - end of line
bindkey '^?' backward-delete-char                   # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
    bindkey "${terminfo[kdch1]}" delete-char        # [Delete] - delete forward
else
    bindkey "^[[3~" delete-char                     # [Delete] - delete forward
    bindkey "^[3;5~" delete-char
    bindkey "\e[3~" delete-char
fi
bindkey "^A" vi-beginning-of-line
bindkey -M viins "^F" vi-forward-word               # [Ctrl-f] - move to next word
bindkey -M viins "^E" vi-add-eol                    # [Ctrl-e] - move to end of line
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward
bindkey -s ^f "tmux-sessionizer\n"                  # Quick way to start a tmux session with search

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

########################################################
# Plugin setup
########################################################

export ZPLUGDIR="$CACHEDIR/zsh/plugins"
[[ -d "$ZPLUGDIR" ]] || mkdir -p "$ZPLUGDIR"
# array containing plugin information (managed by zfetch)
typeset -A plugins

zfetch mafredri/zsh-async async.plugin.zsh
zfetch zsh-users/zsh-syntax-highlighting
zfetch zsh-users/zsh-autosuggestions
zfetch chriskempson/base16-shell
zfetch Aloxaf/fzf-tab

[[ -e ~/.terminfo ]] && export TERMINFO_DIRS=~/.terminfo:/usr/share/terminfo

########################################################
# Setup
########################################################

source "$DOTFILES/zsh/utils.zsh"

# If a local zshrc exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

if [[ -a ~/.localrc ]]; then
    source ~/.localrc
fi

# add a config file for ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# add color to man pages
export MANROFFOPT='-c'
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)

if dotfiles::exists brew ; then
  # source z.sh if it exists
  zpath="$(brew --prefix)/etc/profile.d/z.sh"
  if [ -f "$zpath" ]; then
      source "$zpath"
  fi
fi

if [ -f /usr/share/fzf/completion.zsh ]; then
  source /usr/share/fzf/completion.zsh
  source /usr/share/fzf/key-bindings.zsh
elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

########################################################
# Aliases
########################################################

# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # macOS `ls`
  colorflag="-G"
fi

# use nvim, but don't make me think about it
if dotfiles::exists apt-get ; then
  alias vim='~/.local/bin/nvim.appimage'
else
  [[ -n "$(command -v nvim)" ]] && alias vim="nvim"
fi

# Git Aliases
alias gs='git status'
alias glog="git l"
alias gcorb='git checkout --track $(git branch -r | fzf)'
alias gcob='git checkout $(git branch | fzf)'
alias gpo='git pull origin'

if dotfiles::exists xdg-open ; then
  alias open="xdg-open"
fi

# System update
if dotfiles::exists apt-get ; then
  alias update='sudo apt-get update && sudo apt-get upgrade'
elif dotfiles::exists brew ; then
  alias update='brew update && brew upgrade && brew doctor'
elif dotfiles::exists paru ; then
  alias update='paru -Syu'
elif dotfiles::exists pacman ; then
  alias update='sudo pacman -Syu'
fi

# Docker stuff
alias dcu='docker-compose up'
alias dcd='docker-compose down'

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# Applications
alias ios='open -a /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
# remove broken symlinks
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

# tmux aliases
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

alias lpath='echo $PATH | tr ":" "\n"' # list the PATH separated by new lines

# list our process using port
alias wtfport="lsof -i -P -n | grep LISTEN"

alias luamake=$HOME/lua-language-server/3rd/luamake/luamake

# Linux Stuff
alias disableLaptop='xrandr --output eDP-1 --off'

# Update/Install Global node dependencies
alias npmpackages='volta install @lifeart/ember-language-server @tailwindcss/language-server bash-language-server cssmodules-language-server diagnostic-languageserver dockerfile-language-server-nodejs ember-cli ls_emmet neovim typescript typescript-language-server vim-language-server vscode-langservers-extracted yaml-language-server'

# Need to source these last
# source "$DOTFILES/zsh/prompt.zsh"

eval "$(starship init zsh)"

source $HOME/.cargo/env
