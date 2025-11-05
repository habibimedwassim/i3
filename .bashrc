#!/bin/bash
#Copy and paste this in .bashrc
#
# ~/.bashrc
#
pfetch
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export EDITOR=vim

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

# Changing "ls" to "eza"
alias ls='eza -al --icons --color=always --group-directories-first' # my preferred listing
alias la='eza -a --icons  --color=always --group-directories-first'  # all files and dirs
alias ll='eza -l --icons --color=always --group-directories-first'  # long format
alias lt='eza -aT --icons --color=always --group-directories-first' # tree listing

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

[ ! -e ~/.dircolors ] && eval $(dircolors -p > ~/.dircolors)
[ -e /bin/dircolors ] && eval $(dircolors -b ~/.dircolors)

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init bash)"
