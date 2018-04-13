alias gco='git checkout'
alias gcorb='gco --track $(git branch -r | fzf)'
alias gcob='gco $(git branch | fzf)'
alias gmb='git merge $(git branch | fzf)'
