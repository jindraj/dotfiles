[[ $- == *i* ]] && true || return
[[ -f ~/.bash_local ]] && source ~/.bash_local
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_functions ]] && source ~/.bash_functions
[[ -x /usr/local/bin/aws ]] && complete -C aws_completer aws

# {{{ BREW 
if which brew &> /dev/null
then
	export HOMEBREW_CASK_OPTS="--caskroom=/usr/local/Caskroom"
	BREW_PREFIX=$(brew --prefix 2>/dev/null)
	[[ -s $BREW_PREFIX/share/bash-completion/bash_completion ]] && source $BREW_PREFIX/share/bash-completion/bash_completion #bash-completion@2
	#[[ -s $BREW_PREFIX/etc/bash_completion ]] && source $BREW_PREFIX/etc/bash_completion #bash-completion
	[[ -s $BREW_PREFIX/etc/profile.d/autojump.sh ]] && . $BREW_PREFIX/etc/profile.d/autojump.sh
else
	if which git &> /dev/null
	then
		[[ -s ~/.git-prompt.sh ]] && source ~/.git-prompt.sh
	else
		__git_ps1() { return; }
	fi
fi
# }}}

shopt -s checkwinsize
shopt -s cdspell
shopt -s autocd

complete -F _ssh sshmux tssh s curl odjebat nc

export LSCOLORS=ExGxFxdxCxegedhbagacec

[ -n "$TMUX" ] && export TERM=screen-256color

# {{{ PATH
PATH="$PATH:$HOME/bin"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="$PATH:/usr/texbin"
PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
# }}}

# {{{ History
# unlimited size of history and history file
# one history file per day
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
#HISTSIZE=
#HISTFILESIZE=
HISTCONTROL=ignoreboth
HISTFILE="${HOME}/.bash_history_files/$(date -u +%Y-%m-%d)"
mkdir -m 700 $(dirname $HISTFILE) 2> /dev/null
ln -sf $HISTFILE ~/.bash_history
# }}}

EDITOR="vim"
SUDO_EDITOR=$EDITOR
export HOMEBREW_EDITOR=$EDITOR

# {{{ PROMPT CONFIGS
PROMPT_DIRTRIM=2
export MYSQL_PS1=$(echo -e "\x01\e[1;30m\x02[\x01\e[0m\x02 \x01\e[1;97m\x02mysql\x01\e[0m\x02\x01\e[1;30m\x02://\x01\e[0m\x02\x01\e[1;32m\x02\u@\h\x01\e[0m\x02\x01\e[1;30m\x02:\x01\e[0m\x02\x01\e[1;97m\x02\p\x01\e[0m\x02 \x01\e[1;34m\x02\d\x01\e[0m\x02 \x01\e[1;30m\x02]\x01\e[0m\x02\n\x01\e[1;34m\x02>\x01\e[0m\x02\_")
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM="auto"
case $TERM in
	xterm*|rxvt*|Eterm|aterm)
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
# }}}

# PAGER, MANPAGER {{{
#if which vimpager &> /dev/null
if [[ -f ~/.vim/plugged/vimpager/vimpager ]]
then 
	export PAGER=~/.vim/plugged/vimpager/vimpager
	export MANPAGER="col -b | $PAGER -c 'set ft=man nomod nolist'"
else
	export PAGER=less
	export MANPAGER="less"
fi
# }}}

# vim:foldmethod=marker:foldlevel=0
