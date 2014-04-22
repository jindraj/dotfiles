[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.bash_functions ]] && source ~/.bash_functions
[[ -s $(brew --prefix)/etc/bash_completion 2>/dev/null ]] && source $(brew --prefix)/etc/bash_completion

shopt -s checkwinsize
shopt -s cdspell
shopt -s histappend

PATH=$PATH:$HOME/bin:/usr/local/sbin
export KRB5_CONFIG=~/.krb5.conf
HISTSIZE=5000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM="auto"
export LSCOLORS=GxFxCxDxBxegedabagaced
export GREP_OPTIONS="--color=auto"
#CDPATH=~/socialbakers/repos/git/puppet:$CDPATH

# PROMPTS CONFIG
PROMPT_DIRTRIM=2
MYSQL_PS1="[ \U:\p/\d ]>\_"
PROMPT1="%R[ %n@%M:%>/%/  ]%#"
[ -n "$TMUX" ] && export TERM=screen-256color
case $TERM in
	linux|xterm*|rxvt*|Eterm|aterm|vt100)
		if [ "$UID" -eq 0 ]
		then
			PS1=' \[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;30m\][\[\e[0m\] \[\e[1;31m\]\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;30m\]]\[\e[1;34m\]\$\[\e[0m\] '
		else
			PS1=' \[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;30m\][\[\e[0m\] \[\e[1;32m\]\u@\h\[\e[1m\] \[\e[1;34m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;30m\]]\[\e[0m\]\[\e[1;34m\]\$\[\e[0m\] '
			#PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;30m\][\[\e[0m\] \[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;30m\]]\[\e[0m\]\[\e[1;34m\]\$\[\e[0m\] '
		fi
	;;
	screen|screen-256color|screen.rxvt)
		if [ "$UID" -eq 0 ]
		then
			PS1=' \[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;34m\][\[\e[0m\] \[\e[1;31m\]\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;34m\]]\[\e[0m\]\[\e[1;32m\]\$\[\e[0m\] '
		else
			PS1=' \[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;34m\][\[\e[0m\] \[\e[1;33m\]\u@\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;34m\]]\[\e[0m\]\[\e[1;32m\]\$\[\e[0m\] '
		fi
	;;
	*)
		PS1='[ \u@\h \w ]\$ '
esac

EDITOR="vim"
SUDO_EDITOR=$EDITOR
if $(which vimpager &> /dev/null) 
then 
	export PAGER="vimpager -c 'ft=man nomod nolist'"
else
	export PAGER="less"
fi
if $(which vimmanpager &> /dev/null) 
then 
	export MANPAGER="vimmanpager"
else
	export MANPAGER="col -b | vimpager -c 'set ft=man nomod nolist'"
fi
