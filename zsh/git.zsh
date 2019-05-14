# git aliases
alias gs='git s'
alias glog='git l'
alias gcorb='git checkout --track $(git branch -r | fzf)'
alias gcob='git checkout $(git branch | fzf)'

function g() {
  if [[ $# > 0 ]]; then
    # if there are arguments, send them to git
    git $@
  else
    # otherwise, run git status
    git s
  fi
}
