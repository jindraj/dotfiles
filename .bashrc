[[ $- == *i* ]] && true || return
[[ -s ~/.bash_local ]] && source ~/.bash_local
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.bash_functions ]] && source ~/.bash_functions
[[ -x /usr/local/bin/aws ]] && complete -C aws_completer aws

if which -s brew
then
	[[ -s $(brew --prefix 2> /dev/null)/etc/bash_completion ]] && source $(brew --prefix 2> /dev/null)/etc/bash_completion
	[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
else
	if which git &> /dev/null
	then
		[[ -s ~/.git-prompt.sh ]] && source ~/.git-prompt.sh
	else
		_git_ps1() { return; }
	fi
fi

shopt -s checkwinsize
shopt -s cdspell
shopt -s histappend
shopt -s autocd

complete -F _ssh sshmux tssh curl odjebat nc

[ -n "$TMUX" ] && export TERM=screen-256color
PATH="$PATH:$HOME/bin"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="$PATH:/usr/texbin"
HISTSIZE=5000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM="auto"
export LSCOLORS=ExGxFxdxCxegedhbagacec
export GREP_OPTIONS="--color=auto"
export KRB5_CONFIG=~/.krb5.conf
EDITOR="vim"
SUDO_EDITOR=$EDITOR

# PROMPTS CONFIG
PROMPT_DIRTRIM=2
export MYSQL_PS1=$(echo -e "[ \u@\h:\p \d ]>\_")
#export MYSQL_PS1=$(echo -e "\e[1;30m[\e[0m \e[1;32m\u@\h:\p\e[0m \e[1;34m\d\e[0m \e[1;30m]\e[0m\e[1;34m>\e[0m\_")
case $TERM in
	linux|xterm*|rxvt*|Eterm|aterm|vt100)
		if [ "$UID" -eq 0 ]
		then
			PS1='$(ec)$(nr_sessions)\[\e[1;30m\][\[\e[0m\] \[\e[1;31m\]\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;30m\]]\[\e[0m\]\[\e[1;34m\]\$\[\e[0m\] '
		else
			PS1='$(ec)$(nr_sessions)\[\e[1;30m\][\[\e[0m\] \[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;30m\]]\[\e[0m\]\[\e[1;34m\]\$\[\e[0m\] '
		fi
	;;
	screen|screen-256color|screen.rxvt)
		if [ "$UID" -eq 0 ]
		then
			PS1='$(ec)$(nr_sessions)\[\e[1;34m\][\[\e[0m\] \[\e[1;31m\]\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;34m\]]\[\e[0m\]\[\e[1;32m\]\$\[\e[0m\] '
		else
			PS1='$(ec)$(nr_sessions)\[\e[1;34m\][\[\e[0m\] \[\e[1;33m\]\u@\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;34m\]]\[\e[0m\]\[\e[1;32m\]\$\[\e[0m\] '
		fi
	;;
	*)
		PS1='[ \u@\h \w ]\$ '
esac

# PAGER, MANPAGER {{{
if which -s vimpager
then 
	export PAGER="vimpager -c 'ft=man nomod nolist'"
else
	export PAGER="less"
fi

if which -s vimmanpager
then 
	export MANPAGER="vimmanpager"
elif which -s vimpager
then
	export MANPAGER="col -b | vimpager -c 'set ft=man nomod nolist'"
else
	export MANPAGER="less"
fi
# }}}

# vim:foldmethod=marker:foldlevel=0
