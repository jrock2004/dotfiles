# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi

if dotfiles::exists xdg-open ; then
  alias open="xdg-open"
fi

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder
alias reload!='RELOAD=1 source ~/.zshrc'
alias path='echo $PATH | tr -s ":" "\n"'


alias l="ls -lah ${colorflag}"
alias la="ls -AF ${colorflag}"
alias ll="ls -lFh ${colorflag}"
alias lld="ls -l | grep ^d"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# System update
if dotfiles::exists apt-get ; then
  alias update='sudo apt-get update && sudo apt-get upgrade'
elif dotfiles::exists brew ; then
  alias update='brew update && brew upgrade && brew doctor'
fi

# Docker stuff
alias dcu='docker-compose up'
alias dcd='docker-compose down'

# Switch vim to neovim
alias vim="nvim"
