#!/bin/bash
export LANG='en_US.UTF-8'
export LC_COLLATE='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_MESSAGES='en_US.UTF-8'
export LC_MONETARY='en_US.UTF-8'
export LC_NUMERIC='en_US.UTF-8'
export LC_TIME='C'

case $(hostname -f) in
	*.cn-n1-wb.aws.ccl)
		TABRED="255"
		TABGREEN="0"
		TABBLUE="0";;
	*.us-w2.aws.ccl)
		TABRED="144"
		TABGREEN="46"
		TABBLUE="109";;
	*.nag.ccl)
		TABRED="30"
		TABGREEN="144"
		TABBLUE="255";;
	*.pils.ccl)
		TABRED="173"
		TABGREEN="255"
		TABBLUE="47";;
	*.prg.ccl)
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
