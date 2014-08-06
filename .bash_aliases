# ALIASES
alias aman='man -a'
alias bell='echo -en "\a"'
alias cd..='cd ..'
alias curl='curl -g -s'
alias dnscc="sudo kill -HUP $(pgrep dnsmasq)"
alias ec2whoami='curl http://169.254.169.254/latest/meta-data/instance-type;echo'
alias ldapsearch='ldapsearch -x -o ldif-wrap=no -S "" -LLL'
alias l='ls -alh'
alias lstat="stat -lt '%Y-%m-%d %X'"
alias mtr='mtr --curs'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias rsync='rsync -avzhPp --stats'
alias r='sudo -E bash -l'
alias se='sudo vim'
alias vim='vim'
alias vi='vim'
alias tssh='tmux-cssh'
#alias tmux='tmux -2 attach-session || tmux -2'
if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls='ls -G'
else
	alias ls='ls --color=auto'
fi;

# GRC aliases
#alias grc='grc -c ~/.grc/main.conf --colour=auto'
if $(which grc &> /dev/null)
then
	alias ping='grc ping'
	alias ping6='grc ping6'
	alias make='grc make'
	alias gcc='grc gcc'
	alias g++='grc g++'
	alias as='grc as'
	alias ld='grc ld'
	alias ldapsearch='grc ldapsearch -x -o ldif-wrap=no -S "" -LLL' 
fi
