#!/usr/bin/env bash
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'
export LC_MONETARY='en_US.UTF-8'
export LC_NUMERIC='en_US.UTF-8'
export LC_TIME='C'

export PROMPT_COMMAND='
echo -ne "\e]0;${USER}@${HOSTNAME%%.*}: ${PWD/$HOME/\~}\a"
echo -ne "\033]6;1;bg;red;brightness;255\a"
echo -ne "\033]6;1;bg;green;brightness;255\a"
echo -ne "\033]6;1;bg;blue;brightness;255\a"
'

[[ -s ~/.bashrc ]] && source ~/.bashrc

test -e "${HOME}/.iterm2_shell_integration.bash" && {
	source "${HOME}/.iterm2_shell_integration.bash"
	export -f __bp_precmd_invoke_cmd
	export -f __bp_interactive_mode
}
