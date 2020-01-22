dotfiles::exists() {
  command -v "$1" > /dev/null 2>&1
}

dotfiles::is_git() {
  [[ $(command git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]
}