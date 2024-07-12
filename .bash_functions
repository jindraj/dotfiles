#!/usr/bin/env  bash

function aws_session_validity(){
	local expiration_ts now_ts expires_in
	[[ $AWS_SESSION_EXPIRATION ]] || return
	expiration_ts=$(date  -j -f "%FT%T%z" "${AWS_SESSION_EXPIRATION%:*}${AWS_SESSION_EXPIRATION##*:}" '+%s')
	now_ts=$(date +%s)

	expires_in=$((expiration_ts - now_ts))

	if [[ $expires_in -ge 1800 ]] 
	then
		printf ✅
	elif [[ $expires_in -lt 1800 && $expires_in -gt 300 ]] 
	then
		printf ⚠️
	elif [[ $expires_in -lt 300 && $expires_in -gt 0 ]] 
	then
		printf ‼️
	else
		printf ❌
	fi
}

function _jj(){
	find . -type f -name '_jj*' | fzf --exact --select-1 -i ${@:+--query "$*"} | xargs view
}

function webcamsnap(){
	local outputfile
	outputfile="$(mktemp).jpg"
	ffmpeg -ss 00:00:00 -f avfoundation -r 30.000030 -i "0" -t 1 -frames:v 1 -q:v 2 "$outputfile"
	printf 'Snapshot saved to:\n%s\n' "$outputfile"
}

function functionfinder(){
	shopt -s extdebug
	declare -F "$1"
	shopt -u extdebug
}

function doh(){
	local doh_url="${DOH_BASE_URL:-https://cloudflare-dns.com/dns-query}"

	doh_url=$(trurl --url "$doh_url" --append "query=name=$1")
	[[ -n $2 ]] && doh_url=$(trurl --url "$doh_url" --append "query=type=$2")

	curl -H "accept: application/dns-json" "$doh_url"
}

function cdfzf(){
	local __projectdir
	__projectdir=$(
		find "$HOME/$__rootdir" -type d -execdir test -d {}/.git \; -prune -print \
			| fzf --exact --select-1 -i ${@:+--query "$*"}
	)
	cd "$__projectdir" || return
}

function ,mstp(){
	,cklb "gitlab.com/mailstep" "${@:-}"
}

function ,cklb(){
	local -x __rootdir="${FUNCNAME[0]/,/}"
	cdfzf "$@"
}

function ,projects(){
	local -x __rootdir="${FUNCNAME[0]/,/}"
	cdfzf "$@"
}

function ,sbks(){
	local -x __rootdir="${FUNCNAME[0]/,/}"
	cdfzf "$@"
}

# {{{ terraform
function tfkubeconfig(){ # get kubeconfig from terraform output and save it as .kubeconfig.NAME
	terraform output --json "$1" | jq .kubeconfig | yq e . > ".kubeconfig.$1"
}

function tf(){ # terraform wrapper with environment picker
	local TF_cmd=$1
	shift
	local -x TF_CLI_ARGS

	if [[ -d ./variables ]]
	then
		var_file=$(find ./variables -type f | fzf -1 -q "$@")
		tf_environment=$(awk -F '"' '/^environment[[:space:]]/ { print $2}' "$var_file")
		TF_CLI_ARGS+=" -var-file=$var_file"
		export TF_WORKSPACE=$tf_environment
		direnv allow
		eval "$(direnv export bash)"
		unset TF_WORKSPACE
	fi
	terraform "$TF_cmd"
	unset TF_CLI_ARGS
}

function tfa(){ # terraform apply wrapper utilizing tf()
	tf apply "$@"
}

function tfp(){ # terraform plan wrapper utilizing tf()
	tf plan "$@"
}

function tfpnl(){ # terraform plan -lock=false wrapper utilizing tf()
	local -x TF_CLI_ARGS_plan="-lock=false"
	tfp "$@"
}
# }}}

__local_getMFA () {
    totp "$1"
}
export -f __local_getMFA

# {{{ Functions used in PS1.
function ec(){ # get exitcode
	local EC=$?
	[[ "$EC" -eq 0 || "$EC" -eq 130 ]] && return
	printf '\x01%b\x02[\x01%b\x02\x01%b\x02%d\x01%b\x02\x01%b\x02]\x01%b\x02' "$__c1" "$crst" '\e[1;31m' "$EC" "$crst" "$__c1" "$crst"
}

function aws_ps1(){
	[[ -z $AWS_PROFILE || $AWS_PROFILE == 'default' || ${AWS_PROFILE@a} != *x* ]] && return
	printf "\x01%b\x02[\x01%b\x02\x01%b\x02%s\x01%b\x02\x01%b\x02]\x01%b\x02" "$__c1" "$crst" '\e[1;31m' "$AWS_PROFILE" "$crst" "$__c1" "$crst"
}

function nr_sessions(){ # get number of tmux+screen sessions
	local TMUX_SESSIONS SCREEN_SESSIONS
	TMUX_SESSIONS=$(tmux list-sessions 2> /dev/null | wc -l)
	SCREEN_SESSIONS=$(screen -list 2> /dev/null | grep -c $'\t')
	[[ $TERM == screen* ]] && SCREEN_SESSIONS=$(( SCREEN_SESSIONS - 1 ))
	(( SCREEN_SESSIONS + TMUX_SESSIONS == 0 )) && return
	printf '\x01%b\x02[\x01%b\x02%d\x01%b\x02]\x01%b\x02' "$__c1" "$crst" "$(( SCREEN_SESSIONS + TMUX_SESSIONS ))" "$__c1" "$crst" 
}
# }}}

function source_all_files_from_dir(){
	[[ ! -d "$1" ]] && return
	local comp
	for comp in "$1/"${2:-*}
	do
		# shellcheck source=/dev/null
		[[ -f $comp ]] && source "$comp"
	done
}

function totp(){  gopass totp -o "$1" ; }
export -f totp

function totpc(){ gopass totp -c "$1" ; }

function aws_pick_profile(){
	export AWS_PROFILE
	AWS_PROFILE=$(aws configure list-profiles | fzf --sort)
}

function aws_add_creds(){
	aws configure set "profile.$1.aws_access_key_id"                    "$2"
	aws configure set "profile.$1.aws_secret_access_key"                "$3"
	printf 1>&2 'Created aws profile %s and swithced to it temporarily' "$1" 
	aws sts get-caller-identity && export AWS_PROFILE=$1
}

function aws_ips(){
	local region=$1 service=$2 filter
	if [[ $region && $service ]]
	then
		filter=".prefixes[]|select((.network_border_group==\"$region\") and .service==\"$service\")"
	elif [[ $service ]]
	then
		filter=".prefixes[]|select(.service==\"$service\")"
	elif [[ $region ]]
	then
		filter=".prefixes[]|select(.network_border_group==\"$region\")"
	else
		filter=""
	fi
	curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq "$filter"
}

function gl_path(){
	p 627f2c5 <<<"
	\set QUIET on
	\timing off
	\t
	\a
	\f '\t'
	\set QUIET off
	SELECT n.path AS namespace,
				p.path AS project,
				concat('/srv/git/repositories/'||disk_path||'.git') AS path
			FROM project_repositories pr
			LEFT JOIN projects p ON p.id=pr.project_id
			LEFT JOIN namespaces n ON n.id=p.namespace_id
			WHERE concat(n.path||'/'||p.path) LIKE '%$1%' ORDER BY 1,2" | column -t
}

function hf(){ # history fuzzy search
	local -a cmds
	local cmd
	local -x FZF_DEFAULT_OPTS
	FZF_DEFAULT_OPTS+='--preview "/bin/echo {} | fold -w $COLUMNS" '
	FZF_DEFAULT_OPTS+='--preview-window=down:33% '
	FZF_DEFAULT_OPTS+='--multi '
	FZF_DEFAULT_OPTS+='--print0 '
	FZF_DEFAULT_OPTS+='--tac '
	FZF_DEFAULT_OPTS+='--bind="esc:execute(pbcopy <<<{})" '
	FZF_DEFAULT_OPTS+='--header="When multiple commands selected with [TAB] they'\''re executed in the same oreder as selected"'
	readarray -d '' -t cmds < <(cat ~/.bash_history_files/* | fzf)
	for cmd in "${cmds[@]}"
	do
		$cmd
	done
}

function kk(){ ps -ef | fzf -m  --preview='cat {}' --preview-window down,wrap | awk '{print $2}' | xargs kill; }

function dt(){ date -j -f %Y%m%d%H%M%S "$1" +%s; } # date time to ts

function td(){ date -j -f %s "$1" +'%F %R:%S'; } # ts to date time

function cd_wifi(){
	local ip
	ip=$(dig +short cdwifi.cz "@$(route -n get default | awk '/gateway/{printf $2}')")
	curl "http://$ip/portal/api/vehicle/gateway/user/authenticate?category=internet&url=http%3A%2F%2Fcdwifi.cz%2Fportal%2Fapi%2Fvehicle%2Fgateway%2Fuser%2Fsuccess&onerror=http%3A%2F%2Fcdwifi.cz%2Fportal%2Fapi%2Fvehicle%2Fgateway%2Fuser%2Ferror" \
	-H 'Host: cdwifi.cz' \
	-H 'Accept: application/json' \
	-H 'Referer: http://cdwifi.cz/captive' \
	--compressed \
	-INSsk

	while :
	do
		curl "http://$ip/portal/api/vehicle/gateway/user" | jq
		sleep 300
	done
}

function zlatestranky(){
	local pattern=$1
	[[ -z $pattern ]] && { cat -; return; }
	shift
	[[ ${#FUNCNAME[*]} -eq 1 ]] && {
		rg -z -i "$pattern" "$HOME/Downloads/fb_cz.txt.gz" | zlatestranky "$@"
		return
	}
	rg -i "$pattern" | zlatestranky "$@"
}

function __wifiqr_complete(){
	readarray -t ssids < <(
		security dump-keychain | \
			grep 'AirPort network password' -B4 | \
			awk -F= '/acct/ {print $2}'
	)
	complete -W "${ssids[*]}" wifiqr
}

function wifiqr(){ qrencode -t ANSIUTF8 -o - "WIFI:T:WPA;S:$*;P:$(security find-generic-password -D 'AirPort network password' -a "$*" -w);;"; }

function ldapaudit(){
	local filter
	[[ "$#" -eq 0 ]] && printf 'usage: %s timeRangeHigherThen [timeRangeLowerThen] [filter]\ntimeRanges are in YYYYMMDDHHMMSS.uuuuuuZ\nFilter is &ed with the timeranges filter (&(timeRangeHigherThen)(timeRangeLowerThen)(filter))\a\n' "$0" && return
	[[ "$#" -eq 1 ]] && filter="reqStart>=$1"
	[[ "$#" -eq 2 ]] && filter="(&(reqstart>=$1)(reqStart<=$2))"
	[[ "$#" -ge 3 ]] && filter="(&(reqstart>=$1)(reqStart<=$2)$3)"
	ldapsearch -W -S reqStart -bcn=accesslog "$filter" reqStart reqMod reqDn reqType
}

function sshmux(){ ssh -vt "${1:-hopnode}" 'tmux attach || tmux'; }

function moshmux(){ TERM=xterm-256color mosh "${1:-hopnode}" tmux attach; }

function removedia(){ iconv -f utf8 -t ascii//TRANSLIT | sed 's/[^a-zA-Z 0-9,]//g'; }

function hst2(){ # create histogram from output of `uniq -c`
	local -x RATIO=${1:-1}
	awk '{print $1" "$2}' | perl -e '
	use POSIX;
	while(<>){
		chomp;
		my @a=split(/ /);
		print $a[1] . " " . "█" x (ceil($a[0]/$ENV{'RATIO'})) . "\n";
	}'
}

function hst(){
	local -x RATIO=${1:-1}
	awk '{print $1" "$2}' | perl -e '
	use POSIX;
	while(<>){
		chomp;
		my @a=split(/ /);
		print $a[1] . " " . "+" x (ceil($a[0]/$ENV{'RATIO'})) . "\n";
	}'
}

function psg(){ pgrep -i -a -l -f "$@"; }

function odjebat(){ ssh-keygen -R "$1" && ssh -o 'StrictHostKeyChecking=no' "$1"; }

function genpasswd(){ LC_CTYPE=C tr -dc '[:print:]' < /dev/urandom | head -c "${1:-20}"; } # password generator

function rpbcopy(){ # copy to system clipboard from remote hosts
	printf '\033]1337;CopyToClipboard=;\a'
	cat -
	pintf '\033]1337;EndCopy\a'
}

function prefix(){ # prefix stdout with date,time or whatever you want
	local prefix=
	function __prefix_helper(){
		case $1 in
			"ts")   prefix=$(date +%s) ;;
			"date") prefix=$(date +%Y-%m-%dT%H:%M:%S) ;;
			"time") prefix=$(date +%H:%M:%S) ;;
			*)      prefix="$1"  ;;
		esac
		[[ "$2" = "-n" ]] || prefix="$(echo -e "\\x01\\e[1;37m\\x02${prefix}\\x01\\e[0m\\x02:\t")"
	}
	
	while read -r
	do
		__prefix_helper "$@"
		printf '%s%s\n' "$prefix" "$REPLY"
	done
}

function keychain_get_internet_password(){ # not using anymore
	[[ $# -ne 2 ]] && { printf 'usage:\n  %s <server> <user>\n' "${FUNCNAME[0]}"; return 1; }
	security find-internet-password -gs "$1" -a "$2" -w | tr -d '\n'
}

function proxy(){
	local proxyport=1080
	local proxyhost=127.0.0.1
	local sshhost=hopnode

	function __proxy_unset(){
		unset all_proxy no_proxy
		sed -i "" '/_proxy=/d' ~/.bash_local
	}

	function __proxy_export(){
		export all_proxy=socks://$proxyhost:$proxyport/
		export no_proxy=localhost,127.0.0.1,::1,ccl
		cat <<-EOF >> ~/.bash_local
		export all_proxy=socks://$proxyhost:$proxyport/
		export no_proxy=localhost,127.0.0.1,::1,ccl
		EOF
	}

	function __proxy_start(){
		ssh $sshhost -o VisualHostKey=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PermitLocalCommand=no -Nfnaxqv -M -S /tmp/ssh_proxy_sock -D $proxyport 2>/tmp/ssh_proxy_stats && \
		networksetup -setsocksfirewallproxy Wi-Fi $proxyhost $proxyport # -setproxybypassdomains localhost 127.0.0.1 ::1 ccl&& \
		printf '\e[1;32mProxy started\e[0m\n'
	}

	function __proxy_stop(){
		ssh $sshhost -o VisualHostKey=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PermitLocalCommand=no -q -S /tmp/ssh_proxy_sock -O exit > /dev/null && \
		networksetup -setsocksfirewallproxystate Wi-Fi off -setproxybypassdomains Empty && \
		printf '\e[0;33mProxy statistics:\e[0m\n'
		tail /tmp/ssh_proxy_stats | grep -e second -e compress --color=no
		rm /tmp/ssh_proxy_stats
		printf '\e[1;31mProxy stopped\e[0m\n'
	}

	function __proxy_status(){
		printf '\e[0;33mSystem SOCKS5 configuration:\e[0m\n'
		networksetup -getsocksfirewallproxy Wi-Fi
		printf '\e[0;33mbash environment variables:\e[0m\n'
		env | grep --colour=never "_proxy=" || true
		printf '\e[0;33mssh dynamic tunnel:\e[0m\n'
		ssh $sshhost -o VisualHostKey=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PermitLocalCommand=no -q -S /tmp/ssh_proxy_sock -O check || true
	}

	function __proxy_help(){
		cat <<-EOF
		proxy <start|stop|status|clean>
		
		start:  start ssh dynamic tunnel, enable socks5 proxy, export variables
		stop:   stop ssh tunnel, disable socks5 proxy , unset variables
		status: print information about proxying
		clean:  unset variables
		EOF
	}
	
	case "$1" in
		"status")
			__proxy_status;;
		"clean")
			__proxy_unset;;
		"start")
			__proxy_start
			__proxy_export
			__proxy_status;;
		"stop")
			__proxy_stop
			__proxy_unset
			__proxy_status;;
		*)
			__proxy_help;;
	esac
	__proxy_help
	printf "\a"
	return 1
}
export -f		\
	ec			\
	nr_sessions
# vim:foldmethod=indent:foldlevel=0:tabstop=4:shiftwidth=4:softtabstop=0:noexpandtab
