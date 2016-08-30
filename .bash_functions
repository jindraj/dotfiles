#!/bin/bash
function __jenkins() {
	local cur tasks
	cur="${COMP_WORDS[COMP_CWORD]}"
	tasks="$(~/bin/jenkins --jobs)"
	COMPREPLY=( $(compgen -W "$tasks" $cur) )
}
complete -o default -F __jenkins jenkins c

# Functions used in PS1.
## Prepend PS1 with exitcode if not OK
function ec {
	EC=$?
	[[ "$EC" -ne 0 ]] && [[ "$EC" -ne 130 ]] && echo -en "\x01\e[1;30m\x02[\x01\e[0m\x02\x01\e[1;31m\x02${EC}\x01\e[0m\x02\x01\e[1;30m\x02]\x01\e[0m\x02"
}
## Prepend PS1 with number of tmux+screen sessions
function nr_sessions {
	TMUX_SESSIONS=$(tmux list-sessions 2> /dev/null|wc -l)
	SCREEN_SESSIONS=$(screen -list 2> /dev/null |grep $'\t'|wc -l)
	[[ $TERM == screen* ]] && SCREEN_SESSIONS=$(($SCREEN_SESSIONS - 1))
	[[ $(($SCREEN_SESSIONS+$TMUX_SESSIONS)) -gt 0 ]] && \
	echo -en "\x01\e[1;30m\x02[\x01\e[0m\x02$(($SCREEN_SESSIONS+$TMUX_SESSIONS))\x01\e[1;30m\x02]\x01\e[0m\x02"
}

function cpcmd(){
	#[[ "$OSTYPE" == "darwin"* ]] && pbcopy <<<"${@}"
	[[ "$OSTYPE" == "darwin"* ]] && sed -e 's/\([;|&]\)/\\\1/g' <<<"${@}" | pbcopy
	[[ "$OSTYPE" == "linux"* ]] && rpbcopy <<<"${@}"
}

function ldapaudit() {
  [[ "$#" -eq 0 ]] && echo -e "usage: $0 timeRangeHigherThen [timeRangeLowerThen] [filter]\ntimeRanges are in YYYYMMDDHHMMSS.uuuuuuZ\nFilter is &ed with the timeranges filter (&(timeRangeHigherThen)(timeRangeLowerThen)(filter))\a" && return
  [[ "$#" -eq 1 ]] && filter="reqStart>=$1"
  [[ "$#" -eq 2 ]] && filter="(&(reqstart>=$1)(reqStart<=$2))"
  [[ "$#" -ge 3 ]] && filter="(&(reqstart>=$1)(reqStart<=$2)$3)"
  ldapsearch -W -S reqStart -bcn=accesslog "$filter" reqStart reqMod reqDn reqType 
}

function sshmux() {
	ssh -v4t ${1:-omnius.jakubjindra.eu} 'tmux attach || tmux'
}

function ns() {
	netstat -W $@ | column -t 
}

# Remove diacritics - dosn't work correctly on osx
function removedia() {
	[[ "$OSTYPE" == "darwin"* ]] && \
		echo -e "ERR: This works only on linux… fix me\a" 1>&2 && exit 1 || \
		iconv -f utf8 -t ASCII//TRANSLIT
}

# create histogram from output of `uniq -c`
function hst(){
  export local RATIO=${1:-1}
  awk '{print $1" "$2}' | perl -e '
    use POSIX;
    while(<>){
      chomp;
      my @a=split(/ /);
      print $a[1] . " " . "+" x (ceil($a[0]/$ENV{'RATIO'})) . "\n";
    }'
}

# ps grep
function psgg() {
	ps auxww | grep -i "$*"
}
function psg() {
	ps auxww | grep -v grep | grep -i "$*"
}

function odjebat() {
	ssh-keygen -R $1 && ssh -o 'StrictHostKeyChecking=no' $1
}

# Password generator
function genpasswd() {
	LC_CTYPE=C tr -dc A-Za-z0-9_-.:%@ < /dev/urandom | head -c ${1:-20} | xargs
}

# Get MY passwords
function mygetpass() {
	local GPG_ENCRYPTED_FILE="$HOME/Documents/.pass/my.gpg"
	local GPG_USER_ID='Jakub Jindra'
	gpg --no-batch -d -r '${GPG_USER_ID}' ${GPG_ENCRYPTED_FILE} 2> /dev/null | grep -i $1 | column -t
}

# Get SBKS passwords
function getpass() {
	local GPG_ENCRYPTED_FILE="$HOME/socialbakers/passwords.gpg"
	local GPG_USER_ID='Jakub Jindra'
	gpg --no-batch -d -r '${GPG_USER_ID}' ${GPG_ENCRYPTED_FILE} 2> /dev/null | grep -i $1 | column -t
}

function refreshpass() {
	local GPG_ENCRYPTED_FILE="$HOME/socialbakers/passwords.gpg"
	rm -f $GPG_ENCRYPTED_FILE
	ssh -q adm1.svc.nag.ccl 'sudo cat /root/.pass.new' | gpg --no-batch -e --recipient "Jakub Jindra" -o $GPG_ENCRYPTED_FILE
}

function ipwan(){
	[ "$1" == "-n" ] \
		&& dig +short myip.opendns.com @resolver1.opendns.com|tr -d '\n' \
		|| dig +short myip.opendns.com @resolver1.opendns.com
}

function jsoncurl(){
	curl "$@" | json
}

function ccurl() {
	curl "$@" | grcat ~/.grc/conf.curl
}

if [[ "$OSTYPE" == "darwin"* ]]; then
	growl(){
		if [[ $# -ge 1 ]]; then
			message=$@
		else
			while IFS= read; do
				message+=$REPLY
			done
		fi	
		echo -en "\e]9;$(tr '\n' ' ' <<<"$message"|cut -c -37)\a"
	}
fi

function rpbcopy(){
	echo -ne "\033]1337;CopyToClipboard=;\a"
	while IFS=$'\n' read -r; do
		echo "$REPLY"
	done
	echo -ne "\033]1337;EndCopy\a"
}

function prefix(){
	__prefix_helper(){
		case $1 in
			"ts")   prefix=$(date +%s) ;;
			"date") prefix=$(date +%Y-%m-%dT%H:%M:%S) ;;
			"time") prefix=$(date +%H:%M:%S) ;;
			*)    prefix="$1"  ;;
		esac
		[[ "$2" = "-n" ]]   || prefix="\x01\e[1;37m\x02${prefix}\x01\e[0m\x02"
		echo -en "$prefix"
	}

	IFS='
	'
	while IFS= read -r
	do 
		prefix=$(__prefix_helper $@)
		echo -e "$REPLY" | sed "s/^/$prefix:	/"
	done
}


function keychain_get_internet_password(){
	[[ $# -ne 2 ]] && \
		echo "usage: $FUNCNAME server user" || \
		security find-internet-password -gs "$1" -a "$2" -w | tr -d '\n'
}

function proxy(){
	local proxyport=1080
	local proxyhost=127.0.0.1
	local sshhost=home-http-proxy

	__proxy_unset(){
		unset all_proxy no_proxy
		sed -i "" '/_proxy=/d' ~/.bash_local
	}
	__proxy_export(){
		export all_proxy=socks://$proxyhost:$proxyport/
		export no_proxy=localhost,127.0.0.1,::1
		(echo "export all_proxy=socks://$proxyhost:$proxyport/";
		echo "export no_proxy=localhost,127.0.0.1,::1") >> ~/.bash_local
	}
	__proxy_start(){
		ssh $sshhost -o VisualHostKey=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PermitLocalCommand=no -Nfnaxqv -M -S /tmp/ssh_proxy_sock -D $proxyport 2>/tmp/ssh_proxy_stats && \
		networksetup -setsocksfirewallproxy Wi-Fi $proxyhost $proxyport && \
		echo -e '\e[1;32mProxy started\e[0m'
	}
	__proxy_stop(){
		ssh $sshhost -o VisualHostKey=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PermitLocalCommand=no -q -S /tmp/ssh_proxy_sock -O exit > /dev/null && \
		networksetup -setsocksfirewallproxystate Wi-Fi off && \
		echo -e "\e[0;33mProxy statistics:\e[0m"
		tail /tmp/ssh_proxy_stats | grep -e second -e compress --color=no
		rm /tmp/ssh_proxy_stats
		echo -e '\e[1;31mProxy stopped\e[0m'
	}
	__proxy_status(){
		echo -e "\e[0;33mSystem SOCKS5 configuration:\e[0m"
		networksetup -getsocksfirewallproxy Wi-Fi
		echo -e "\e[0;33mbash environment variables:\e[0m"
		env | grep --colour=never "_proxy=" || true
		echo -e "\e[0;33mssh dynamic tunnel:\e[0m"
		ssh $sshhost -o VisualHostKey=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PermitLocalCommand=no -q -S /tmp/ssh_proxy_sock -O check || true
	}
	__proxy_help(){
		echo "proxy start | stop | status | clean"
		echo
		echo "start:  start ssh dynamic tunnel, enable socks5 proxy, export variables"
		echo "stop:   stop ssh tunnel, disable socks5 proxy , unset variables"
		echo "status: print information about proxying"
		echo "clean:  unset variables"
	}

	if [ "$#" -eq 0 ]; then
		__proxy_help
	elif [ "$#" -eq 1 ]; then
		case "$1" in
			"status")
				__proxy_status
			;;"clean")
				__proxy_unset
			;;"start")		
				__proxy_start
				__proxy_export
				__proxy_status
			;;"stop")
				__proxy_stop
				__proxy_unset
				__proxy_status
			;;*)
				__proxy_help
			;;
		esac
	else
		__proxy_help
		echo -e "\a"
		return 1	 
	fi
}
