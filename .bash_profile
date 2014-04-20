#!/bin/bash
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'
export LC_MONETARY='en_US.UTF-8'
export LC_NUMERIC='en_US.UTF-8'
export LC_TIME='C'

export PROMPT_COMMAND='
echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"
echo -ne "\033]6;1;bg;red;brightness;140\a"
echo -ne "\033]6;1;bg;green;brightness;140\a"
echo -ne "\033]6;1;bg;blue;brightness;140\a"
'

[[ -s ~/.bashrc ]] && source ~/.bashrc
