#!/bin/bash
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'
export LC_MONETARY='en_US.UTF-8'
export LC_NUMERIC='en_US.UTF-8'
export LC_TIME='C'

case $(hostname -f) in
	*.aws.ccl)
		DC="aws"
		TABRED="255"
		TABGREEN="20"
		TABBLUE="147";;
	*.nag.ccl)
		DC="nag"
		TABRED="30"
		TABGREEN="144"
		TABBLUE="255";;
	*.pils.ccl)
		DC="pils"
		TABRED="173"
		TABGREEN="255"
		TABBLUE="47";;
	*.prg.ccl)
		DC="prg"
		TABRED="173"
		TABGREEN="255"
		TABBLUE="47";;
	*)
		TABRED="255"
		TABGREEN="255"
		TABBLUE="255";;
esac

export PROMPT_COMMAND='
echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"
echo -ne "\033]6;1;bg;red;brightness;$TABRED\a"
echo -ne "\033]6;1;bg;green;brightness;$TABGREEN\a"
echo -ne "\033]6;1;bg;blue;brightness;$TABBLUE\a"
'

[[ -s ~/.bashrc ]] && source ~/.bashrc
if [[ -s ~/.iterm2_shell_integration.bash ]]; then
	source ~/.iterm2_shell_integration.bash
else
	iterm2_shell_integration_url="http://iterm2.com/misc/install_shell_integration.sh"
	if which curl &> /dev/null; then
		curl -L $iterm2_shell_integration_url | bash 2> /dev/null
	elif which wget &> /dev/null; then
		wget $iterm2_shell_integration_url -o /dev/null -O /dev/stdout | sed -e 's@curl -L@wget -O /dev/stdout@g' | bash 2> /dev/null
	else
		echo "Couldn't locate curl or wget binary to fetch iTerm2 shell integration script"
	fi
	unset iterm2_shell_integration_url
	perl -p -i -e 's/PROMPT_COMMAND="preexec_invoke_cmd";/PROMPT_COMMAND="\${PROMPT_COMMAND}preexec_invoke_cmd";/g' ~/.iterm2_shell_integration.bash
	source ~/.iterm2_shell_integration.bash
fi
