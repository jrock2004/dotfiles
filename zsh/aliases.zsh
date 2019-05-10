# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

alias vim="nvim"

# Filesystem aliases
alias path='echo $PATH | tr -s ":" "\n"'
alias rmf="rm -rf"

if xdg-open > /dev/null 2>&1; then
  alias open="xdg-open"
fi

# Fancy weather
alias wttr='curl -4 http://wttr.in/honey_brook'
alias wttrw='curl -4 http://wttr.in/lansdale'
alias moon='curl -4 http://wttr.in/Moon'

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# System update
if apt-get > /dev/null 2>&1; then
  alias update="sudo apt-get update && sudo apt-get upgrade"
elif brew > /dev/null 2>&1; then
  alias update="brew update && brew upgrade && brew doctor"
fi

# Docker stuff
alias dcu='docker-compose up'
alias dcd='docker-compose down'
