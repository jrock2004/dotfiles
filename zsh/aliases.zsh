# Aliases
source $DOTFILES/zsh/aliases/git.zsh

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

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder
alias apps='dpkg -l | awk "{print \$2 \"\\t\" \$3}" | fzf' # Fuzzy search of installed apps

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# View HTTP traffic
alias httpdump="sudo tcpdump -i enp0s31f6 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# System update
alias update="sudo eopkg upgrade"

# Better tmux support
alias tmux='tmux -2'

# Search for npm apps to install
alias yarnig='all-the-package-names | fzf | xargs sudo yarn global add'
alias yarni='all-the-package-names | fzf | xargs sudo yarn add'

