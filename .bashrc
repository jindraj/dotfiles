shopt -s checkwinsize
shopt -s cdspell

[ -n "$XTERM_VERSION" ] && transset -a >/dev/null
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

#               
# PS1 SETTINGS, Functions and variables
PROMPT_DIRTRIM=2
## git functions
### Prints git branch name
function parse_git_branch() {
	if $(which git &> /dev/null)
	then
		git branch 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1 /"
	fi
}

### Returns colored git branch name
function parse_git_ci {
	if git rev-parse --git-dir &> /dev/null
	then
		if [[ $(git status 2> /dev/null | tail -n1) = "nothing to commit, working directory clean" ]]
		then
			echo -ne "\e[0;36m$(parse_git_branch)\e[0m"
		else
			echo -ne "\e[1;31m$(parse_git_branch)\e[0m"
		fi
	fi
}

# Exitcode function
## Echos exitcode if differs from 0 or 130
function ec {
	EC=$?
	if [[ "$EC" -ne 0 ]] && [[ "$EC" -ne 130 ]] 
		then
			echo -ne "\a$EC "
		fi
}

# PS1
case $TERM in
	linux|xterm*|rxvt*|Eterm|aterm|vt100)
		if [ "$UID" -eq 0 ]
		then
			PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;30m\][\[\e[0m\] \[\e[1;31m\]\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\] \[$(parse_git_ci)\]\[\e[1;30m\]]\[\e[0m\]\[\e[1;34m\]\$\[\e[0m\] '
		else
			PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;30m\][\[\e[0m\] \[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\] \[$(parse_git_ci)\]\[\e[1;30m\]]\[\e[0m\]\[\e[1;34m\]\$\[\e[0m\] '
		fi
	;;
	screen|screen.rxvt)
		if [ "$UID" -eq 0 ]
		then
			PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;34m\][\[\e[0m\] \[\e[1;31m\]\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\] \[$(parse_git_ci)\]\[\e[1;34m\]]\[\e[0m\]\[\e[1;32m\]\$\[\e[0m\] '
		else
			PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;34m\][\[\e[0m\] \[\e[1;33m\]\u@\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\] \[$(parse_git_ci)\]\[\e[1;34m\]]\[\e[0m\]\[\e[1;32m\]\$\[\e[0m\] '
		fi
	;;
	*)
		PS1='[ \u@\h \w ]\$ '
esac

# History configuration
shopt -s histappend
HISTSIZE=5000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth

# ALIASES
alias bell='echo -en "\a"'
alias cd..='cd ..'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias l='ls -alh'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias rsync='rsync -avzhPp --stats'
alias r='sudo -E bash -l'
alias s='ssh'
alias se='sudoedit'
alias vim='vim'
alias vi='vim'
alias lastfmplay='mplayer-lastfm-0.2.7.pl mplayer'
alias mtr='mtr --curs'
alias aman='man -a'
alias ldapsearch='ldapsearch -x -o ldif-wrap=no -S "" -LLL'
alias winbox='WINEPREFIX="/home/jakub.jindra/.wine_prefixes/winbox" wine ~/bin/winbox.exe &'
alias ads='sw/ApacheDirectoryStudio-linux-x86_64-2.0.0.v20120224/ApacheDirectoryStudio &'
alias reshome='xrandr --output LVDS --mode 1920x1080 --output VGA-0 --mode 1440x900 --right-of LVDS'
alias ressbks='xrandr --output LVDS --mode 1920x1080 --output HDMI-0 --mode 1920x1080 --right-of LVDS'

# GRC aliases
#alias grc='grc -c ~/.grc/main.conf --colour=auto'
if $(which grc &> /dev/null)
then
	alias ping='grc ping'
	alias make='grc make'
	alias gcc='grc gcc'
	alias g++='grc g++'
	alias as='grc as'
	alias ld='grc ld'
	alias ldapsearch='grc ldapsearch'
fi

# VARIABLES
export EDITOR="vim"
export SUDO_EDITOR=$EDITOR
if $(which vimpager &> /dev/null) 
then 
	export PAGER="vimpager"
else
	export PAGER="vimpager"
fi
if $(which vimmanpager &> /dev/null) 
then 
	export MANPAGER="vimmanpager"
else
	export MANPAGER="less"
fi


# Set MySQL and PostgreSQL prompt
export MYSQL_PS1="[ \U:\p/\d ]>\_"
export PROMPT1="%R[ %n@%M:%>/%/  ]%#"

# disable vsync on ATI Radeon HD4650
export vblank_mode=0


# Remove diacritics
removedia() {
	iconv -t ASCII//TRANSLIT
}

# Password generator
genpasswd() {
	local l=$1
	[ "$l" == "" ] && l=20
	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

# WEP key generator
wepgen() {
	local l=$1
	[ "$l" == "" ] && l=20
	tr -dc ABCDEF0123456789 < /dev/urandom | head -c ${l} | xargs
}

# Get MY passwords
mygetpass() {
	GPG_ENCRYPTED_FILE="$HOME/documents/.pass/my.gpg"
	GPG_USER_ID='Jakub Jindra'
	gpg --batch -d -r '${GPG_USER_ID}' ${GPG_ENCRYPTED_FILE} 2> /dev/null | grep $1 -i | column -t
}

# Get SBKS passwords
getpass() {
	GPG_ENCRYPTED_FILE="$HOME/socialbakers/passwords.gpg"
	GPG_USER_ID='Jakub Jindra'
	gpg --batch -d -r '${GPG_USER_ID}' ${GPG_ENCRYPTED_FILE} 2> /dev/null | grep $1 -i | column -t
}

refreshpass() {
	GPG_ENCRYPTED_FILE="$HOME/socialbakers/passwords.gpg"
	rm $GPG_ENCRYPTED_FILE
	ssh adm-1.gogrid.ccl 'sudo cat /root/.pass.new' | gpg --batch -e --recipient "Jakub Jindra" -o $GPG_ENCRYPTED_FILE
}
# Put your fun stuff here.
export PATH=$PATH:~/bin
