# Portable aliases + functions shared by both shells:
#   - macOS: sourced from files/.zshrc
#   - Omarchy: sourced from bash/omarchy.bash (via ~/.bashrc)
# Keep this parseable by BOTH bash and zsh: no zsh globs, no bashisms.

dotfiles::exists() { command -v "$1" >/dev/null 2>&1; }

# --- editor ----------------------------------------------------------------
dotfiles::exists nvim && alias vim='nvim'
alias vim2='NVIM_APPNAME=ownnvim nvim'

# --- shell ---------------------------------------------------------------- -
alias reload='exec "$SHELL"'
alias grep='grep --color=auto'
alias lpath='echo "$PATH" | tr ":" "\n"'
alias wtfport='lsof -i -P -n | grep LISTEN'

# --- listing (eza) -------------------------------------------------------- -
if dotfiles::exists eza; then
    alias ls='eza -GHF'
    alias ll='eza --icons=always'
fi

# --- open (native on macOS, xdg-open elsewhere) -------------------------- -
dotfiles::exists open || { dotfiles::exists xdg-open && alias open='xdg-open'; }

# --- git ---------------------------------------------------------------- - -
alias gs='git status'
alias glog='git l'
alias gpo='git pull origin'
alias gcob='git checkout "$(git branch | sed "s/^[* ]*//" | fzf)"'
alias gcorb='git checkout --track "$(git branch -r | sed "s/^[* ]*//" | fzf)"'

# --- system update (first match wins) --------------------------------------
if dotfiles::exists omarchy; then
    alias updateSystem='omarchy update'
elif dotfiles::exists brew; then
    alias updateSystem='brew update && brew upgrade && brew doctor'
elif dotfiles::exists paru; then
    alias updateSystem='paru -Syu'
elif dotfiles::exists pacman; then
    alias updateSystem='sudo pacman -Syu'
elif dotfiles::exists apt-get; then
    alias updateSystem='sudo apt-get update && sudo apt-get upgrade'
fi

# --- housekeeping -------------------------------------------------------- - -
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

# --- node package-manager switches ------------------------------------------
alias switchtoyarn='rm -Rf node_modules && rm -f package-lock.json yarn.lock pnpm-lock.yaml && yarn install'
alias switchtopnpm='rm -Rf node_modules && rm -f package-lock.json yarn.lock pnpm-lock.yaml && pnpm install'
alias switchtonpm='rm -Rf node_modules && rm -f package-lock.json yarn.lock pnpm-lock.yaml && npm install'

# --- stow (dotfiles symlink management) ----------------------------------- -
if dotfiles::exists pacman; then
    # Omarchy: keep its own nvim/ghostty/lazygit configs and skip mac-only zsh files
    alias sync='stow --ignore="(nvim|ghostty|lazygit)" --ignore="^\.(zshrc|zprofile|zshenv|p10k\.zsh)$" --ignore="\.DS_Store" -v -R -t ~ -d "$DOTFILES" files'
else
    alias sync='stow --ignore="\.DS_Store" -v -R -t ~ -d "$DOTFILES" files'
fi
alias unsync='stow --ignore="\.DS_Store" -v -D -t ~ -d "$DOTFILES" files'

# --- functions ---------------------------------------------------------- - -
f()     { find . -name "$1"; }
fkill() { kill -9 "$(ps ax | fzf | awk '{ print $1 }')"; }
md()    { mkdir -p "$1" && cd "$1" || return; }

resetjsnode() {
    rm -Rf node_modules
    [ -e pnpm-lock.yaml ] && pnpm install
    [ -e yarn.lock ] && yarn install
    [ -e package-lock.json ] && npm install
}

rimage() {
    local image
    image="$(docker images | fzf | awk '{print $3}')" || return
    [ -n "$image" ] && docker rmi "$image"
}
