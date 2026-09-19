# cargo env is sourced in .zshenv (before p10k instant prompt runs)

# Announce a `reload` (shell/common.sh) here — before the instant prompt block
# below captures console output — so it doesn't trip p10k's warning. Consuming
# the flag now also stops common.sh from printing it again when sourced later.
[[ -n "$_RELOADED" ]] && { print -P "🔄 Shell reloaded"; unset _RELOADED; }

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
source "$DOTFILES/zsh/utils.zsh"

# Variables
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
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS

# Path
prepend_path /usr/local/opt/grep/libexec/gnubin
prepend_path /usr/local/sbin
prepend_path $DOTFILES/bin
prepend_path $VOLTA_HOME/bin
prepend_path $HOME/.local/lib/python3.9/site-packages
prepend_path $HOME/.local/bin

# Work Stuff
export SONARQUBE_TOKEN=$(security find-generic-password -s sonarqube-token -w)

if [[ -d /usr/local/go/bin ]]; then
  prepend_path /usr/local/go/bin
fi

if dotfiles::exists brew ; then
  # source z.sh if it exists
  zpath="$(brew --prefix 2>/dev/null)/etc/profile.d/z.sh"
  if [ -f "$zpath" ]; then
      source "$zpath"
  fi
fi

# Aliases + functions shared with bash (see shell/common.sh)
source "$DOTFILES/shell/common.sh"

# zsh / macOS-only aliases
alias ios='open -a /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'
alias luamake=$HOME/lua-language-server/3rd/luamake/luamake

# Install/update the global npm tooling (list shared with bin/update)
npmpackages() {
  local pkgs
  pkgs="$(cat "$DOTFILES/scripts/npm-global-packages.txt")"
  volta install ${=pkgs}
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"

  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

else
  export PNPM_HOME="$HOME/.config/pnpm"
fi
export PATH="$PNPM_HOME/bin:$PNPM_HOME:$PATH"

if dotfiles::exists pnpm ; then
  export PATH="$PATH:$(pnpm root -g 2>/dev/null)/.pnpm"
fi

# AWS Easy Command
alias awsprofile='source ~/.aws/set_aws_profile.sh'

function s2alogin {
  saml2aws login --browser-autofill --skip-prompt --force
  if [ $? -eq 0 ]; then
    source ~/.aws/set_aws_profile.sh
  fi
}

export SAML2AWS_BROWSER_EXECUTABLE_PATH="$HOME/Library/Caches/ms-playwright/chromium-1217/chrome-mac-arm64/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing"
