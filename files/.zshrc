########################################################
# Variables
########################################################
export CACHEDIR="$HOME/.local/share"
export DOTFILES=$HOME/.dotfiles
export EDITOR='nvim'
export GIT_EDITOR='nvim'
export LANG='en_US'
export LC_ALL='en_US.UTF-8'
export SHELL=$(which zsh)
export ZPLUGDIR="$CACHEDIR/zsh/plugins"
export ZSH="$DOTFILES/scripts/zsh"

########################################################
# Configurations
########################################################

if [[ -d $ZSH/functions ]]; then
  for func in $ZSH/functions/*(:t); autoload -U $func
fi

# initialize autocomplete
autoload -U compinit add-zsh-hook
compinit

# display how long all tasks over 10 seconds take
export REPORTTIME=10

setopt NO_BG_NICE
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt PROMPT_SUBST

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# history
setopt EXTENDED_HISTORY
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS

setopt COMPLETE_ALIASES

# prepend_path $HOME/npmbin/node_modules/.bin
if [ -z ${RELOAD} ]; then
  export PATH="$PATH:$DOTFILES/bin"
fi

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

fpath=($ZSH/functions $fpath)
autoload -U $ZSH/functions/*(:t)

source $ZSH/functions.zsh
source $ZSH/utils.zsh

########################################################
# Plugin setup
########################################################

[[ -d "$ZPLUGDIR" ]] || mkdir -p "$ZPLUGDIR"

# array containing plugin information (managed by zfetch)
typeset -A plugins

zfetch $ZPLUGDIR zsh-users/zsh-syntax-highlighting
zfetch $ZPLUGDIR zsh-users/zsh-autosuggestions


########################################################
# Setup
########################################################

# FZF Configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Prompt
setopt PROMPT_SUBST
source $ZSH/git_prompt.zsh
source $ZSH/node_prompt.zsh

PROMPT='
%F{#c678dd}%~ %F{#61afef}$(git_status)%f
%F{#c678dd}❯ '

RPROMPT='%F{#56b6c2}$(node_prompt)%f'

########################################################
# Aliases
########################################################
alias reload!='RELOAD=1 source ~/.zshrc'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # macOS `ls`
    colorflag="-G"
fi

# git aliases
alias gs='git status'
alias gcorb='git checkout --track $(git branch -r | fzf)'
alias gcob='git checkout $(git branch | fzf)'
alias gpo='git pull origin'

# use nvim, but don't make me think about it
alias vim="nvim"

alias path='echo $PATH | tr -s ":" "\n"'

if dotfiles::exists xdg-open ; then
  alias open="xdg-open"
fi

alias grep='grep --color=auto'

# System update
if dotfiles::exists apt-get ; then
  alias update='sudo apt-get update && sudo apt-get upgrade'
elif dotfiles::exists brew ; then
  alias update='brew update && brew upgrade && brew doctor'
fi

# Docker stuff
alias dcu='docker-compose up'
alias dcd='docker-compose down'

# Clean up DS_Store
alias rmdstore='find . -name ".DS_Store" -depth -exec rm {} \'
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
