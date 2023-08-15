#!/usr/bin/env bash
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'
export LC_MONETARY='en_US.UTF-8'
export LC_NUMERIC='en_US.UTF-8'
export LC_TIME='C'

export PROMPT_COMMAND='
printf "\e]0;${USER}@${HOSTNAME%%.*}: ${PWD/$HOME/\~}\a"
printf "\e]6;1;bg;red;brightness;255\a"
printf "\e]6;1;bg;green;brightness;255\a"
printf "\e]6;1;bg;blue;brightness;255\a"
'

# shellcheck source=.bashrc
[[ -s $HOME/.bashrc ]] && source "$HOME/.bashrc"

if [[ -e "${HOME}/.iterm2_shell_integration.bash" ]]
then
	# shellcheck source=.iterm2_shell_integration.bash
	source "${HOME}/.iterm2_shell_integration.bash"
	export -f __bp_precmd_invoke_cmd \
		__bp_interactive_mode    \
		__iterm2_prompt_command  \
		__bp_set_ret_value       \
		__iterm2_preexec         \
		iterm2_print_state_data  \
		iterm2_prompt_mark       \
		iterm2_prompt_prefix     \
		iterm2_prompt_suffix     \
		iterm2_begin_osc         \
		iterm2_end_osc           \
		iterm2_print_user_vars
fi

ulimit -n 4096
ulimit -Hn 4096
