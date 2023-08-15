#!/usr/bin/env bash

[[ $- != *i* ]] && return
# shellcheck source=.bash_local
[[ -f ~/.bash_local      ]] && source "$HOME/.bash_local"
# shellcheck source=.bash_aliases
[[ -f ~/.bash_aliases    ]] && source "$HOME/.bash_aliases"
# shellcheck source=.bash_functions
[[ -f ~/.bash_functions  ]] && source "$HOME/.bash_functions"

command -v brew &> /dev/null && BREW_PREFIX=$(brew --prefix 2>/dev/null)

#jira completion bash > "$HOME/.bash_completion.d/jira"
#curl https://raw.githubusercontent.com/notmuch/notmuch/master/completion/notmuch-completion.bash -o "$HOME/.bash_completion.d/notmuch-completion.bash
source_all_files_from_dir "$HOME/.bash_completion.d/"
source_all_files_from_dir "$BREW_PREFIX/etc/profile.d/" '*.sh'
source_all_files_from_dir "$BREW_PREFIX/etc/bash_completion.d/"

[[ -n $PS1 ]] && complete -F _known_hosts sshmux tssh s curl odjebat nc ,sensu-agent-restart
[[ -n $PS1 ]] && complete -F _gopass_bash_autocomplete totp totpc
[[ -n $PS1 ]] && __wifiqr_complete

shopt -s mailwarn
shopt -s checkwinsize
shopt -s cdspell
shopt -s autocd

export LSCOLORS=ExGxFxdxCxegedhbagacec

# {{{ History
# unlimited size of history and history file one history file per day
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
HISTCONTROL=ignoreboth
HISTFILE="${HOME}/.bash_history_files/$(date -u +%Y-%m-%d)"
mkdir -p -m 700 "$(dirname "$HISTFILE")"
ln -sf "$HISTFILE" "$HOME/.bash_history"
# }}}

# {{{ PROMPT CONFIGS
PROMPT_DIRTRIM=2
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWCOLORHINTS=true

__c1_normal='\e[1;30m' __c2_normal='\e[1;32m' __c3_normal='\e[1;34m'
__c1_screen='\e[1;34m' __c2_screen='\e[1;33m' __c3_screen='\e[1;32m'
__c2_root='\e[1;31m'
printf -v crst '%b' '\e[0m'

case $TERM in
	xterm*|rxvt*|Eterm|aterm)
		__c1=$(printf '%b' "$__c1_normal") __c2=$(printf '%b' "$__c2_normal") __c3=$(printf '%b' "$__c3_normal")
		[[ "$UID" -eq 0 ]] && __c2=$(printf '%b' "$__c2_root")
		PS1='$(ec)$(nr_sessions)$(aws_ps1)\[$__c1\][\[$crst\] \[$__c2\]\u@\h\[$crst\] \[\e[1;34m\]\w\[$crst\]$(__git_ps1) \[$__c1\]]\[$crst\]\[$__c3\]\$\[$crst\] '
	;;
	screen*)
		__c1=$(printf '%b' "$__c1_screen")
		__c2=$(printf '%b' "$__c2_screen")
		__c3=$(printf '%b' "$__c3_screen")
		[[ "$UID" -eq 0 ]] && __c2=$(printf '%b' "$__c2_root")
		PS1='$(ec)$(nr_sessions)$(aws_ps1)\[$__c1\][\[$crst\] \[$__c2\]\u@\h\[$crst\] \[\e[1;34m\]\w\[$crst\]$(__git_ps1) \[$__c1\]]\[$crst\]\[$__c3\]\$\[$crst\] '
	;;
	*)
		PS1='[ \u@\h \w ]\$ '
	;;
esac
# }}}

# EDITOR, PAGER, MANPAGER {{{
export EDITOR=vim
if command -v nvim > /dev/null
then
	EDITOR=nvim
	alias vim=nvim
fi

export SUDO_EDITOR=$EDITOR
export HOMEBREW_EDITOR=$EDITOR

export BAT_PAGER=cat
export PAGER=less
export MANPAGER=$PAGER
if [[ -f $HOME/.config/nvim/plugged/vimpager/vimpager ]]
then 
	PAGER=$HOME/.config/nvim/plugged/vimpager/vimpager
	alias vimpager='$PAGER'
	MANPAGER="$SHELL -c \"col -b | $PAGER -c 'set ft=man nomod nolist'\""
fi
# }}}

# {{{ PERL - spamassassin testing
PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
# }}}

# vim:foldmethod=marker:foldlevel=0
