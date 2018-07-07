[[ $- == *i* ]] && true || return
[[ -f ~/.bash_local ]] && source ~/.bash_local
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_functions ]] && source ~/.bash_functions
[[ -x /usr/local/bin/aws ]] && complete -C aws_completer aws

# {{{ BREW 
if command -v brew &> /dev/null
then
	BREW_PREFIX=$(brew --prefix 2>/dev/null)
	[[ -s $BREW_PREFIX/share/bash-completion/bash_completion ]] && source $BREW_PREFIX/share/bash-completion/bash_completion #bash-completion@2
	#[[ -s $BREW_PREFIX/etc/bash_completion ]] && source $BREW_PREFIX/etc/bash_completion #bash-completion
	[[ -s $BREW_PREFIX/etc/profile.d/autojump.sh ]] && . $BREW_PREFIX/etc/profile.d/autojump.sh
else
	if command -v git #&> /dev/null
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

# {{{ PATH
PATH="$PATH:$HOME/bin"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/bin:$PATH"
# }}}

# {{{ History
# unlimited size of history and history file one history file per day
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
HISTCONTROL=ignoreboth
HISTFILE="${HOME}/.bash_history_files/$(date -u +%Y-%m-%d)"
mkdir -p -m 700 $(dirname $HISTFILE)
ln -sf $HISTFILE ~/.bash_history
# }}}

# {{{ PROMPT CONFIGS
export MYSQL_PS1=$(echo -e "\x01\e[1;30m\x02[ \x01\e[1;97m\x02mysql\x01\e[1;30m\x02://\x01\e[1;32m\x02\u@\h\x01\e[1;30m\x02:\x01\e[1;97m\x02\p\x01\e[1;30m\x02/\x01\e[1;34m\x02\d\x01\e[1;30m\x02 ]\n\x01\e[1;34m\x02>\x01\e[0m\x02\x01\e[0m\x02\_")
PROMPT_DIRTRIM=2
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

# EDITOR, PAGER, MANPAGER {{{
if command -v nvim > /dev/null
then
	EDITOR=nvim
else
	EDITOR=vim
fi
SUDO_EDITOR=$EDITOR
export HOMEBREW_EDITOR=$EDITOR

if [[ -f ~/.config/nvim/plugged/vimpager/vimpager ]]
then 
	alias vimpager=~/.config/nvim/plugged/vimpager/vimpager
	export PAGER=~/.config/nvim/plugged/vimpager/vimpager
	export MANPAGER="/bin/bash -c \"col -b | $(echo $PAGER) -c 'set ft=man nomod nolist'\""
else
	export PAGER=less
	export MANPAGER=$PAGER
fi
# }}}

# vim:foldmethod=marker:foldlevel=0
