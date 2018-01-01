#!/bin/bash
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'
export LC_MONETARY='en_US.UTF-8'
export LC_NUMERIC='en_US.UTF-8'
export LC_TIME='C'

export PROMPT_COMMAND='
echo -ne "\e]0;${USER}@${HOSTNAME%%.*}: ${PWD/$HOME/\~}\a"
'

[[ -s ~/.bashrc ]] && source ~/.bashrc
