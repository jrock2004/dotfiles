set -gx PATH $PATH "$HOME/.dotfiles/bin"
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH $PATH "$VOLTA_HOME/bin"

if exists apt-get
  alias update='sudo apt-get update && sudo apt-get upgrade'
else if exists brew
  alias update='brew update && brew upgrade && brew doctor'
end

