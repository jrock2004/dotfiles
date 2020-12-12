set -gx VOLTA_HOME "$HOME/.volta"

if not contains $HOME/.dotfiles/bin $PATH
  set -a PATH $HOME/.dotfiles/bin
end

if not contains $VOLTA_HOME/bin $PATH
  set -a PATH $VOLTA_HOME/bin
end

if contains (uname) "Linux"
  set -a HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
  set -a HOMEBREW_CELLAR $HOMEBREW_PREFIX/Cellar
  set -a HOMEBREW_REPOSITORY $HOMEBREW_PREFIX/Homebrew
  set -a PATH $HOMEBREW_PREFIX/bin
  set -a MANPATH $HOMEBREW_PREFIX/share/man
  set -a INFOPATH $HOMEBREW_PREFIX/share/info
end

# set PATH $PATH /home/linuxbrew/.linuxbrew/bin

if exists apt-get
  alias update='sudo apt-get update && sudo apt-get upgrade'
else if exists brew
  alias update='brew update && brew upgrade && brew doctor'
end

alias gcob="git checkout (git branch | fzf | sed -e 's/^[ \t]*//')"
alias gcorb="git checkout --track (git branch -r | fzf | sed -e 's/^[ \t]*//')"
alias rmdstore="find . -name '.DS_Store' -depth -exec rm {} \;"
alias wtfport="lsof -i -P -n | grep LISTEN"
alias ios='open -a /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'

