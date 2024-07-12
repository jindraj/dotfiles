#!/usr/bin/env bash
alias k9s='TERM=xterm k9s'
alias mtr='TERM=xterm mtr'
alias deluge-console='TERM=xterm deluge-console'
alias calout='remind -m@2,0,0c2 -b1 -gdddd ~/.reminders/team_out.rem'
alias calweek='rem -m@2,0,0cl+2 -b1 -gdddd'
alias calmonth='rem -m@2,0,0cl1 -b1 -gdddd'
alias kubenodes='kubectl get nodes --label-columns kubernetes.io/hostname,node.kubernetes.io/server,topology.kubernetes.io/zone,beta.kubernetes.io/instance-type --sort-by={.metadata.labels."node\.kubernetes\.io\/server"}'
alias jiv='jira issues view --comments 100'
alias jil='jira issues list'
alias jel='jira epic list'
alias bat='PAGER=cat bat'
alias aman='man -a'
alias bell='printf "\a"'
alias bsvc='brew services'
alias cd..='cd ..'
alias chromekill="ps ux | grep '[C]hrome Helper (Renderer)' | grep -v extension-process | awk '{print "\$2"}'|xargs kill"
alias counts='sort | uniq -c | sort -g'
alias curl='curl -g -s'
alias dnscc='sudo kill -HUP $(pgrep dnsmasq); sudo killall -HUP mDNSResponder; sudo dscacheutil -flushcache'
alias gitcd='cd $(git rev-parse --show-toplevel)'
alias focus='echo -ne "\033]50;StealFocus\a"'
alias h='history'
alias hgrep='history | rg'
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/'
alias k='kubectl'
alias l='ls -alh'
alias ldapsearch='ldapsearch -x -o ldif-wrap=no -S "" -LLL'
alias ldapvi='ldapvi -D "cn=jakub jindra,ou=people,dc=socialbakers,dc=com"' #sed -n '/^BINDDN/ s/^BINDDN[[:space:]]\{1,\}//p' $HOME/.ldaprc
alias lstat="stat -lt '%Y-%m-%d %X'"
alias mysql='mysql -C --pager="pspg -X -F --force-uniborder"'
alias nocomment="grep -Ev '^($|\s*#)'"
alias nocolor="perl -pe 's/\e\[[\d;]*m//g;'"
alias puppet-lint='puppet-lint --no-documentation-check'
alias r='sudo -E bash -l'
alias rsync='rsync -avzhPp --stats'
alias se='sudo $EDITOR'
alias tssh='TMUX_XPANES_PANE_BORDER_STATUS=" " TMUX_XPANES_PANE_BORDER_FORMAT="#[reverse] #T #[default]" tmux-xpanes --ssh'
alias vi='vim'
alias urlencode='python3 -c "import sys,urllib.parse; print(urllib.parse.quote_plus(sys.stdin.read()));"'
alias urldecode='python3 -c "import sys,urllib.parse; print(urllib.parse.unquote_plus(sys.stdin.read()));"'
alias qpencode='python3 -c "import sys,quopri; print(quopri.encodestring(sys.stdin.read(),quotetabs=True));"'
alias qpdecode='python3 -c "import sys,quopri; print(quopri.decodestring(sys.stdin.read()));"'
alias nsunique='awk '\''!mem[$0]++'\'


if [[ "$OSTYPE" == "darwin"* ]]; then
	alias ls='ls -G --color=always'
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
