set -gx VOLTA_HOME "$HOME/.volta"

if not contains $HOME/.dotfiles/bin $PATH
  set -a PATH $HOME/.dotfiles/bin
end

if not contains $VOLTA_HOME/bin $PATH
  set -a PATH $VOLTA_HOME/bin
end

set PATH $PATH /home/linuxbrew/.linuxbrew/bin

if exists apt-get
  alias update='sudo apt-get update && sudo apt-get upgrade'
else if exists brew
  alias update='brew update && brew upgrade && brew doctor'
end

alias gcob="git checkout (git branch | fzf | sed -e 's/^[ \t]*//')"
alias gcorb="git checkout --track (git branch -r | fzf | sed -e 's/^[ \t]*//')"
alias rmdstore="find . -name '.DS_Store' -depth -exec rm {} \;"
