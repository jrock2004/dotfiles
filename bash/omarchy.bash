# Dotfiles bash config for Omarchy.
# Sourced from ~/.bashrc (install.sh appends the source line). Omarchy's own
# bash rc runs first; anything here intentionally overrides it.

export DOTFILES="$HOME/.dotfiles"
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"
export EDITOR="nvim"
export GIT_EDITOR="nvim"

# Path (Omarchy's env-bootstrap already handles ~/.local/bin and mise shims)
[[ -d "$DOTFILES/bin" ]] && export PATH="$DOTFILES/bin:$PATH"

# fzf
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Shared aliases + functions (also sourced by .zshrc on macOS)
[ -f "$DOTFILES/shell/common.sh" ] && . "$DOTFILES/shell/common.sh"
