# .bashrc

[ -z "$PS1" ] && return

. ~/.env
[[ -f ~/.secretenv ]] && . ~/.secretenv

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# set vi mode
set -o vi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# source: https://github.com/scop/bash-completion/blob/main/README.md#installation
[[ ! ${BASH_COMPLETION_VERSINFO:-} &&
  -f /usr/share/bash-completion/bash_completion ]] &&
    . /usr/share/bash-completion/bash_completion

# User specific environment

alias ls="ls --color=auto"
export GPG_TTY=$(tty)

export PS1='[\[\e[1;35m\]\w\[\e[0m\]@\[\e[1;34m\]\H\[\e[0m\]]\n\$ '

VIRTUAL_ENV_DISABLE_PROMPT=1
. ~/.venv/bin/activate

[[ $(uname -s) == "Darwin" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

_scancel_fzf_completion() {
  local selected_jobs
  selected_jobs=$(squeue --me | tail -n +2 | fzf --multi --prompt="Select jobs to cancel: " | awk '{print $1}' | paste -sd' ' -)
  if [[ -n "$selected_jobs" ]]; then
    COMPREPLY=("$selected_jobs")
  else
    COMPREPLY=()
  fi
}

complete -F _scancel_fzf_completion scancel

eval "$(fzf --bash)"
eval "$(zoxide init bash)"

alias yacc="bison"
alias today="date +%Y_%m_%d"

ovrpush() {
  while true; do
    if ! git pull; then
      return 1
    fi

    if git push; then
      return 0
    fi
  done
}
