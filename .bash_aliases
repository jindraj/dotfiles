# ALIASES
alias devconf="curl https://147.229.254.98/login.php -H 'Host: wifigw.cis.vutbr.cz' -H 'Origin: https://wifigw.cis.vutbr.cz' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Referer: https://wifigw.cis.vutbr.cz/login.php' --data 'user=devconfcz&auth=any&password=atfit16' --compressed -D - -o /tmp/devconf.html -k"
alias mcd="curl 'http://172.30.105.1/login' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Referer: http://172.30.105.1/login?dst=http%3A%2F%2Fzcu.cz%2F' -H 'Cookie: lastLogin=1453227537838' --data 'username=user&password=4158c3c81510a5e1a369eb359e937cb6&dst=http%3A%2F%2Fzcu.cz%2F&popup=false'"
alias cd_pendolino="curl -H 'Host: www.ombord.info' 'https://10.0.1.254/hotspot/hotspot.cgi?method=login&username=lab&password=CAEN&realm=lab' -kIL"
alias cd_rj79="curl -H 'Host: www.ombord.info' 'https://10.0.0.1/hotspot/hotspot.cgi?connect=Connect&method=login&username=lab&password=CAEN&realm=lab'-kIL"
alias aman='man -a'
alias bell='echo -en "\a"'
alias cd..='cd ..'
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | awk '{print "\$2"}'|xargs kill"
alias counts='sort | uniq -c | sort -g'
alias curl='curl -g -s'
alias curlins='curl -L -u $JENKINS_API_USER:$JENKINS_API_TOKEN'
alias dnscc="sudo kill -HUP $(pgrep dnsmasq); sudo killall -HUP mDNSResponder; sudo dscacheutil -flushcache"
alias ec2whoami='curl http://169.254.169.254/latest/meta-data/instance-type;echo'
alias gitcd='cd $(git rev-parse --show-toplevel)'
alias focus='echo -ne "\033]50;StealFocus\a"'
alias h='history'
alias hgrep='history | grep'
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/'
alias json='python -mjson.tool'
alias jsonc='python -mjson.tool|grcat ~/.grc/conf.curl'
alias l='ls -alh'
alias ldapsearch='ldapsearch -x -o ldif-wrap=no -S "" -LLL'
alias lstat="stat -lt '%Y-%m-%d %X'"
alias mtr='mtr --curs'
alias nocomment="grep -Ev '^($|\s*#)'"
alias nocolor="perl -pe 's/\e\[[\d;]*m//g;'"
alias r='sudo -E bash -l'
alias rsync='rsync -avzhPp --stats'
alias s='ssh'
alias se='sudo $EDITOR'
alias scat='slackcli --token $SLACK_API_TOKEN -u "Jakub Jindra"i -i https://en.gravatar.com/userimage/35972117/b0d611d9e0bdca05ff4950adb892c154.jpg?size=200'
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
