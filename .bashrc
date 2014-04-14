[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -s ~/.bash_functions ]] && source ~/.bash_functions

shopt -s checkwinsize
shopt -s cdspell
shopt -s histappend

PATH=$PATH:$HOME/bin:/usr/local/sbin
HISTSIZE=5000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM="auto"
#LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:a"
export GREP_OPTIONS="--color=auto"
#CDPATH=~/socialbakers/repos/git/puppet:$CDPATH
PROMPT_DIRTRIM=2

# PS1
case $TERM in
	linux|xterm*|rxvt*|Eterm|aterm|vt100)
		if [ "$UID" -eq 0 ]
		then
			PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;30m\][\[\e[0m\] \[\e[1;31m\]\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]$(__git_ps1) \[\e[0m\]]\[\e[1;34m\]\$\[\e[0m\] '
		else
			PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;30m\][\[\e[0m\] \[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;30m\]]\[\e[0m\]\[\e[1;34m\]\$\[\e[0m\] '
		fi
	;;
	screen|screen.rxvt)
		if [ "$UID" -eq 0 ]
		then
			PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;34m\][\[\e[0m\] \[\e[1;31m\]\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;34m\]]\[\e[0m\]\[\e[1;32m\]\$\[\e[0m\] '
		else
			PS1='\[\e[1;31m\]$(ec)\[\e[0m\]\[\e[1;34m\][\[\e[0m\] \[\e[1;33m\]\u@\h\[\e[0m\] \[\e[1;32m\]\w\[\e[0m\]$(__git_ps1) \[\e[1;34m\]]\[\e[0m\]\[\e[1;32m\]\$\[\e[0m\] '
		fi
	;;
	*)
		PS1='[ \u@\h \w ]\$ '
esac
[ -n "$TMUX" ] && export TERM=screen-256color
MYSQL_PS1="[ \U:\p/\d ]>\_"
PROMPT1="%R[ %n@%M:%>/%/  ]%#"


# ALIASES
alias bell='echo -en "\a"'
alias cd..='cd ..'
alias lstat="stat -lt '%Y-%m-%d %X'"
alias ls='ls -G'
alias l='ls -alh'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias rsync='rsync -avzhPp --stats'
alias r='sudo -E bash -l'
alias s='ssh'
alias se='sudo vim'
alias vim='vim'
alias vi='vim'
alias mtr='mtr --curs'
alias aman='man -a'
alias ldapsearch='ldapsearch -x -o ldif-wrap=no -S "" -LLL'

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
	alias ldapsearch='grc ldapsearch -x -o ldif-wrap=no -S "" -LLL' 
fi
    
EDITOR="vim"
SUDO_EDITOR=$EDITOR
if $(which vimpager &> /dev/null) 
then 
	export PAGER="vimpager"
else
	export PAGER="less"
fi
if $(which vimmanpager &> /dev/null) 
then 
	export MANPAGER="vimmanpager"
else
	export MANPAGER="less"
fi
