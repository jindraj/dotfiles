# ALIASES
alias aman='man -a'
alias bell='echo -en "\a"'
alias bsvc='brew services'
alias cd_wifi="curl -H 'Host: www.ombord.info' \"https://$(netstat -rn -f inet| awk '$1=="default" {print $2}')/hotspot/hotspot.cgi?method=login&username=lab&password=CAEN&realm=lab\" -kIL"
alias cd..='cd ..'
alias chromekill="ps ux | grep '[C]hrome Helper (Renderer)' | grep -v extension-process | awk '{print "\$2"}'|xargs kill"
alias counts='sort | uniq -c | sort -g'
alias curl='curl -g -s'
alias curlins='curl -L -u $JENKINS_API_USER:$JENKINS_API_TOKEN'
alias devconf="curl https://147.229.254.98/login.php -H 'Host: wifigw.cis.vutbr.cz' -H 'Origin: https://wifigw.cis.vutbr.cz' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Referer: https://wifigw.cis.vutbr.cz/login.php' --data 'user=devconfcz&auth=any&password=Brno2019' --compressed -D - -o /tmp/devconf.html -k"
alias dnscc='sudo kill -HUP $(pgrep dnsmasq); sudo killall -HUP mDNSResponder; sudo dscacheutil -flushcache'
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
alias mcd="curl 'http://172.30.105.1/login' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Referer: http://172.30.105.1/login?dst=http%3A%2F%2Fzcu.cz%2F' -H 'Cookie: lastLogin=1453227537838' --data 'username=user&password=4158c3c81510a5e1a369eb359e937cb6&dst=http%3A%2F%2Fzcu.cz%2F&popup=false'"
alias mtr='mtr --curs'
alias mysql='mysql -C --pager="pspg -X -F --force-uniborder"'
alias nocomment="grep -Ev '^($|\s*#)'"
alias nocolor="perl -pe 's/\e\[[\d;]*m//g;'"
alias puppet-lint='puppet-lint --no-documentation-check'
alias r='sudo -E bash -l'
alias rsync='rsync -avzhPp --stats'
alias s='ssh'
alias se='sudo $EDITOR'
alias tssh='tmux-cssh -sa -oVisualHostKey=no'
alias vi='vim'
alias urlencode='python -c "import sys,urllib; print urllib.quote_plus(sys.stdin.read());"'
alias urldecode='python -c "import sys,urllib; print urllib.unquote_plus(sys.stdin.read());"'

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
if command -v grc &> /dev/null
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
