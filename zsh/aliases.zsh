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
alias open="xdg-open"

# Fancy weather
alias wttr='curl -4 http://wttr.in/honey_brook'
alias wttrw='curl -4 http://wttr.in/lansdale'
alias moon='curl -4 http://wttr.in/Moon'

# Fuzzy commands with fzf
alias gco='git checkout'
alias gcorb='gco --track $(git branch -r | fzf)'
alias gcob='gco $(git branch | fzf)'

fkill() {
  kill -9 $(ps ax | fzf | awk '{ print $1 }')
}

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}'"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'wlp2s0' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i wlp2s0 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# System update
alias update="sudo apt-get update && sudo apt-get upgrade"
