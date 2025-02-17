# .bashrc
[ -z "$PS1" ] && return

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

export PS1='\[\e[1;35m\]\w\[\e[0m\]\n\$ '
export PATH=$HOME/.local/bin:$PATH
[[ $(uname -s) == "Darwin" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
export EDITOR=hx

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
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

get_sesh_name() {
  hostname | sed 's/\./_/g'
}

alias ta="tmux attach -t $(get_sesh_name)"
alias tc="tmux new -s $(get_sesh_name)"
alias tk="tmux kill-server"
