[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
source "$DOTFILES/zsh/utils.zsh"

# Variables
export DOTFILES=$HOME/.dotfiles
export VOLTA_HOME=$HOME/.volta
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

# Plugins
plug "esc/conda-zsh-completion"
plug "hlissner/zsh-autopair"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/fzf"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "zap-zsh/zap-prompt"
plug "zap-zsh/exa"

# pnpm
export PNPM_HOME="$HOME/.config/pnpm"
export PATH="$PNPM_HOME:$PATH"

# [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

## Allow autocomplete to be insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Functions
if [[ -d $DOTFILES/zsh/functions ]]; then
  for func in $DOTFILES/zsh/functions/*(:t); autoload -U $func
fi

# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000

# Path
prepend_path /usr/local/opt/grep/libexec/gnubin
prepend_path /usr/local/sbin
prepend_path $DOTFILES/bin
prepend_path $VOLTA_HOME/bin
prepend_path $HOME/.local/lib/python3.9/site-packages
prepend_path $HOME/.local/bin

if [[ -d /usr/local/go/bin ]]; then
  prepend_path /usr/local/go/bin
fi

if dotfiles::exists brew ; then
  # source z.sh if it exists
  zpath="$(brew --prefix)/etc/profile.d/z.sh"
  if [ -f "$zpath" ]; then
      source "$zpath"
  fi
fi

# Alias
alias reload!='RELOAD=1 source ~/.zshrc'
[[ -n "$(command -v nvim)" ]] && alias vim="NVIM_APPNAME=LazyVim nvim"
# [[ -n "$(command -v lvim)" ]] && alias vim="lvim"
alias gs='git status'
alias glog="git l"
alias gcorb='git checkout --track $(git branch -r | fzf)'
alias gcob='git checkout $(git branch | fzf)'
alias gpo='git pull origin'

if dotfiles::exists xdg-open ; then
  alias open='xdg-open'
fi

if dotfiles::exists apt-get ; then
  alias update='sudo apt-get update && sudo apt-get upgrade'
elif dotfiles::exists brew ; then
  alias update='brew update && brew upgrade && brew doctor'
elif dotfiles::exists paru ; then
  alias update='paru -Syu'
elif dotfiles::exists pacman ; then
  alias update='sudo pacman -Syu'
fi

alias grep='grep --color=auto'
alias ios='open -a /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"
alias lpath='echo $PATH | tr ":" "\n"'
alias wtfport="lsof -i -P -n | grep LISTEN"
alias luamake=$HOME/lua-language-server/3rd/luamake/luamake
alias disableLaptop='xrandr --output eDP-1 --off'
alias switchtoyarn='rm -Rf node_modules && rm -Rf *-lock.json && yarn install'
alias switchtopnpm='rm -Rf node_modules && rm -Rf *-lock.json && pnpm install'
alias switchtonpm='rm -Rf node_modules && rm -Rf *-lock.json && npm install'
source $HOME/.cargo/env

alias npmpackages='volta install @lifeart/ember-language-server @tailwindcss/language-server bash-language-server cssmodules-language-server diagnostic-languageserver dockerfile-language-server-nodejs ember-cli ls_emmet neovim pnpm typescript typescript-language-server vim-language-server vscode-langservers-extracted yaml-language-server'

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
  export PATH="$PNPM_HOME:$PATH"
else
  export PNPM_HOME="$HOME/.config/pnpm"
fi

if dotfiles::exists pnpm ; then
  export PATH="$PATH:$(pnpm root -g)/.pnpm"
fi

# Stow aliases
alias sync='stow --ignore ".DS_Store" -v -R -t ~ -d "$DOTFILES" files'
alias unsync='stow --ignore ".DS_Store" -v -D -t ~ -d "$DOTFILES" files'

alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=nvim nvim"
alias nvim-default="NVIM_APPNAME=default nvim"

function nvims() {
  items=("default" "nvim" "LazyVim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config="default"
  fi
  NVIM_APPNAME=$config nvim $@
}
