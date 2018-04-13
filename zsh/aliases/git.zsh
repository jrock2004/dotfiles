alias gco='git checkout'
alias gcorb='gco --track $(git branch -rvv | fzf)'
alias gcob='gco $(git branch -vv | fzf)'
alias gmb='git merge $(git branch | fzf)'
