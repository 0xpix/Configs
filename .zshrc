# Ensure the terminal starts in the WSL home directory
cd ~  # Change to the WSL home directory
# -------------------------------
# Performance Optimizations
# -------------------------------
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"
export CONDA_CHANGEPS1=false
# -------------------------------
# Completion System
# -------------------------------
autoload -Uz compinit
compinit -C
# -------------------------------
# Oh My Zsh Configuration
# -------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="edvardm"
# -------------------------------
# Spaceship Prompt Configuration
# -------------------------------
SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="⚡"
SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  git
  line_sep
  char
)
# -------------------------------
# Plugins
# -------------------------------
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-vi-mode
  zoxide
)
# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh
# -------------------------------
# Autosuggestions Configuration
# -------------------------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1
# -------------------------------
# Key Bindings
# -------------------------------
globalias() {
   if [[ $LBUFFER =~ '[a-zA-Z0-9]+$' ]]; then
       zle _expand_alias
       zle expand-word
   fi
   zle self-insert
}
zle -N globalias
bindkey " " globalias
bindkey "^[[Z" magic-space
bindkey -M isearch " " magic-space
# -------------------------------
# SSH Agent Lazy Loading
# -------------------------------
function _load_ssh_agent() {
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add ~/.ssh/id_github_sign_and_auth 2>/dev/null
    fi
}
autoload -U add-zsh-hook
add-zsh-hook precmd _load_ssh_agent
# -------------------------------
# PATH Configuration
# -------------------------------
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH:/home/scott/.turso"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# -------------------------------
# Conda Initialization
# -------------------------------
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pix/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pix/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/pix/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pix/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# -------------------------------
# Starship Prompt
# -------------------------------
eval "$(starship init zsh)"
# -------------------------------
# Source Aliases
# -------------------------------
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
# -------------------------------
# Custom Environment Variables
# -------------------------------
. "$HOME/.local/bin/env"
