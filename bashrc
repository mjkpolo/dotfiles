# .bashrc

[ -z "$PS1" ] && return

. ~/.env
[[ -f ~/.secretenv ]] && . ~/.secretenv

. ~/.venv/bin/activate

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# set vi mode
set -o vi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# User specific environment

alias ls="ls --color=auto"
export GPG_TTY=$(tty)

export PS1='[\[\e[1;35m\]\w\[\e[0m\]@\[\e[1;34m\]\H\[\e[0m\]]\n\$ '

[[ $(uname -s) == "Darwin" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

_scancel_fzf_completion() {
  local selected_job
  selected_job=$(squeue --me | tail -n +2 | fzf --prompt="Select a job to cancel: " | awk '{print $1}')
  if [[ -n "$selected_job" ]]; then
    COMPREPLY=("$selected_job")
  else
    COMPREPLY=()
  fi
}

complete -F _scancel_fzf_completion scancel

eval "$(fzf --bash)"

alias yacc="bison"
alias today="date +%Y_%m_%d"
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
