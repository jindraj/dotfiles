#!/usr/bin/env bash

# shellcheck source=/Users/jindraj/.bash_local
source "$HOME/.bash_local"

function __jira_extract(){
	sed -n "/$1:/ s/.*$1: //p" <<<"$msg"
}

function __jira_choose_action(){
	local action jiraKey

	action="$1"
	jiraKey=$( __jira_extract Key)

	case "$action" in
		"open")
			open -n -a "Google Chrome" --args --profile-directory="Default" "$JIRA_API_BASE_URL/browse/$jiraKey" &
			;;
		"assign")
			jira issue assign "$jiraKey" "$(jira me)"
			;;
		"view")
			[[ -z $TMUX ]] && return
			jira issue view "$jiraKey" --plain --comments 10 | tmux splitw -h -p 50 -I 
			tmux select-pane -t :1.1
			;;
	esac
}

function run(){
	msg=$(cat)
	__jira_choose_action "$@"
}
 
run "$@" &>/dev/null

# vim:foldmethod=indent:foldlevel=0:tabstop=4:shiftwidth=4:softtabstop=0:noexpandtab
