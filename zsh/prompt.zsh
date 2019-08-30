# Load git stuff
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*' formats ' %b'

autoload -Uz add-zsh-hook
setopt prompt_subst

add-zsh-hook precmd vcs_info
add-zsh-hook precmd async_trigger

source "$DOTFILES/zsh/git_prompt.zsh"
source "$DOTFILES/zsh/jobs_prompt.zsh"
source "$DOTFILES/zsh/node_prompt.zsh"

PROMPT_SYMBOL='❯'

precmd() {
  print -P "\n%F{005}%~ $(node_prompt)"
}

export PROMPT='%(?.%F{006}.%F{009})$PROMPT_SYMBOL%f '
export RPROMPT=''

# Required functions
ASYNC_PROC=0
function async() {
  printf "%s" "$(git_status) $(suspended_jobs)" > "/tmp/zsh_prompt_$$"

  kill -s USR1 $$

  if [[ "${ASYNC_PROC}" != 0 ]]; then
    kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
  fi
}

function async_trigger() {
  ASYNC_PROC=$!
  async &!
}

function TRAPUSR1() {
  vcs_info
  RPROMPT='$(cat /tmp/zsh_prompt_$$)'
  ASYNC_PROC=0

  zle && zle reset-prompt
}
