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

export PS1='\[\e[1;35m\]\u@\h\[\e[0m\]:\[\e[1;36m\]\w\[\e[0m\]\$ '
export PATH=$HOME/.local/bin:$PATH
[[ $(uname -s) == "Darwin" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
. "$HOME/.cargo/env"
