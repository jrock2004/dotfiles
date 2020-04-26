set -gx PATH $PATH "$DOTFILES/bin"
set -gx VOLTA_HOME "/Users/jcostanzo/.volta"
set -gx PATH $PATH "$VOLTA_HOME/bin"

if exists apt-get
  alias update='sudo apt-get update && sudo apt-get upgrade'
end

if exists brew
  alias update='brew update && brew upgrade && brew doctor'
end
