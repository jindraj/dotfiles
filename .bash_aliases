# ALIASES
alias aman='man -a'
alias bell='echo -en "\a"'
alias cd..='cd ..'
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | awk '{print "\$2"}'|xargs kill"
alias clr='echo -ne "\e]50;ClearScrollback\a"'
alias counts='sort | uniq -c | sort -g'
alias curl='curl -g -s'
alias curlins='curl -L -u $JENKINS_API_USER:$JENKINS_API_TOKEN'
alias dnscc="sudo kill -HUP $(pgrep dnsmasq); sudo killall -HUP mDNSResponder; sudo dscacheutil -flushcache"
alias ec2whoami='curl http://169.254.169.254/latest/meta-data/instance-type;echo'
alias gitcd='cd $(git rev-parse --show-toplevel)'
alias focus='echo -ne "\033]50;StealFocus\a"'
alias h='history'
alias hgrep='history | grep'
alias json='python -mjson.tool'
alias l='ls -alh'
alias ldapsearch='ldapsearch -x -o ldif-wrap=no -S "" -LLL'
alias lstat="stat -lt '%Y-%m-%d %X'"
alias mtr='mtr --curs'
alias nocomment="grep -Ev '^($|\s*#)'"
alias nocolor="perl -pe 's/\e\[[\d;]*m//g;'"
alias pendolino="curl -H 'Host: www.ombord.info' 'https://10.0.1.254/hotspot/hotspot.cgi?method=login&username=lab&password=CAEN&realm=lab' -kIL"
alias r='sudo -E bash -l'
alias rsync='rsync -avzhPp --stats'
alias s='ssh'
alias se='sudo $EDITOR'
alias tssh='tmux-cssh -sa -oVisualHostKey=no'
alias vi='vim'
alias vpnwho='dig +short -x '
alias urlencode='python -c "import sys,urllib; print urllib.quote_plus(sys.stdin.read());"'

if [[ "$OSTYPE" != "solaris"* ]]; then
	alias grep='grep --color=auto'
	alias egrep='grep --color=auto'
	alias fgrep='grep --color=auto'
	alias zgrep='grep --color=auto'
	alias zegrep='grep --color=auto'
	alias zfgrep='grep --color=auto'
fi
if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls='ls -G'
else
	alias ls='ls --color=auto'
fi;

# GRC aliases
#alias grc='grc -c ~/.grc/main.conf --colour=auto'
if which grc &> /dev/null
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
