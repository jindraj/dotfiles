# ALIASES
alias aman='man -a'
alias bell='echo -en "\a"'
alias cd..='cd ..'
alias curl='curl -g -s'
alias curlins='curl -L -u $JENKINS_API_USER:$JENKINS_API_TOKEN'
alias dnscc="sudo kill -HUP $(pgrep dnsmasq); sudo discoveryutil mdnsflushcache" 
alias ec2whoami='curl http://169.254.169.254/latest/meta-data/instance-type;echo'
alias l='ls -alh'
alias ldapsearch='ldapsearch -x -o ldif-wrap=no -S "" -LLL'
alias lstat="stat -lt '%Y-%m-%d %X'"
alias mtr='mtr --curs'
alias nocomment="grep -Ev '^($|\s*#)'"
alias nocolor="perl -pe 's/\e\[[\d;]*m//g;'"
alias r='sudo -E bash -l'
alias rsync='rsync -avzhPp --stats'
alias se='sudo vim'
alias vim='vim'
alias vi='vim'
alias vpnwho='dig +short -x '
alias tssh='tmux-cssh -sa -oVisualHostKey=no'

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
