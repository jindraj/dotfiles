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
		TABRED="140"
		TABGREEN="140"
		TABBLUE="140";; # change 140 to default for bg color
esac

export PROMPT_COMMAND='
echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/~}\007"
echo -ne "\033]6;1;bg;red;brightness;$TABRED\a"
echo -ne "\033]6;1;bg;green;brightness;$TABGREEN\a"
echo -ne "\033]6;1;bg;blue;brightness;$TABBLUE\a"
'

[[ -s ~/.bashrc ]] && source ~/.bashrc
