# .bashrc

# change home here
export MYHOME=$HOME

export CARGO_HOME=$MYHOME/.cargo
export RUSTUP_HOME=$MYHOME/.rustup
export PATH=$MYHOME/.local/bin:$MYHOME/go/bin:$MYHOME/.local/go/bin:$PATH
export LD_LIBRARY_PATH=$MYHOME/.local/lib:$LD_LIBRARY_PATH
export MANPATH=$MYHOME/.local/share/man:$MANPATH
export PKG_CONFIG_PATH=$MYHOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH

# above no prompt return so makefile can source

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

export PS1='[\[\e[1;35m\]\w\[\e[0m\]@\[\e[1;34m\]\H\[\e[0m\]]\n\$ '

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
alias yacc="bison"
. "$MYHOME/.cargo/env"
. "$MYHOME/.venv/bin/activate"

export YT_PROXY=delta.yt.nebius.yt
export YT_CONFIG_PATCHES="{proxy={force_ipv4=%true}}"
XDG_DATA_DIRS="${XDG_DATA_DIRS}:${MYHOME}/.local/share/flatpak/exports/share"
export UV_CACHE_DIR=$MYHOME/.cache/uv
[[ -f $MYHOME/.hftoken ]] && . $MYHOME/.hftoken
