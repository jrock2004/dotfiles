# tmux aliases
alias ta='tmux attach'
alias td='tmux detach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'
alias fta='tmux attach -t $(tl | fzf | tr ":" "\n" | head -n1)'
alias ftk='tmux kill-session -t $(tl | fzf | tr ":" "\n" | head -n1)'# Fuzzy commands with fzf
