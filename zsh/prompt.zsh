autoload -Uz vcs_info
autoload -Uz add-zsh-hook
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' %b'

PROMPT_SYMBOL='❯'

async_init
async_start_worker vcs_info
# async_register_callback vcs_info git_status_done

export PROMPT='%(?.%F{006}.%F{009})$PROMPT_SYMBOL%f '
