#!/usr/bin/env bash
set -x

function check(){
	if [[ -z "$TMUX" ]]
	then
		clear
		echo -e "neomutt isn't running in tmux…\nexiting"
		exit 1
	fi
}

function init(){
	my_bindir="$(dirname $0)"
	action_scripts=(
		#"$my_bindir/sidecar/freshservice_tasks.sh"
		"$my_bindir/sidecar/ldap.sh"
		"$my_bindir/sidecar/onelogin.sh"
	)
}

function parse(){
	from=$(formail -x From: -z <<<"$msg")
	subject=$(formail -x Subject: -z <<<"$msg")
}

# keeping freshservice only as an example
function guess(){
	case $subject in
		"Task Assigned to Agent")
			guess=$my_bindir/sidecar/freshservice_tasks.sh
			return
			;;
		"Task Closed")
			guess=$my_bindir/sidecar/freshservice_tasks.sh
			return
			;;
	esac
}

function choose_action(){
	# select first pane (neomutt)
	tmux select-pane -t :1.1
	# split plane
	# run choose or guess based on guess()
	# tail pipe into less
	# wait for keypress before exiting
	tmux splitw -h -p 30 "
		action_script=$(printf '%s\n' ${action_scripts[*]}|fzf --query=$guess --select-1)
		\$action_script <<<\"$msg\" | \
		tail -F -n +1 | \
			less -R
			sleep 10
		read
		"
	# select neomutt pane - may become optional
	tmux select-pane -t :1.1
}

function main(){
	msg=$(</dev/stdin)
	check
	init
	parse
	guess
	choose_action
}

main

