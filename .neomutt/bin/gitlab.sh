#!/usr/bin/env bash

# TODO: set token vefore running glab based on the gitlab instance to make it work with multiple gitlabi instances
# shellcheck source=/Users/jindraj/.bash_local
source "$HOME/.bash_local"

TERM=xterm-direct # to fix colors in tmux

function __gitlab_choose_action(){
	local GL_PROJECT_URL GL_CICD_BRANCH action=$1

	GL_PROJECT_URL=$(formail -I '' <<<"$msg" | awk -F '[()]' '/^Project:/ {print $2}' | tr -d ' ')
	GL_CICD_BRANCH=$(formail -z -x X-GitLab-Pipeline-Ref <<<"$msg")

	case "$action" in
		cicd_view)
			glab ci -R "$GL_PROJECT_URL" view -b "$GL_CICD_BRANCH"
			;;
		open)
			glab repo view -w "$GL_PROJECT_URL"
			;;
	esac
}

function run(){
	msg=$(cat)
	__gitlab_choose_action "$@"
}
 
run "$@" #&>/dev/null

# vim:foldmethod=indent:foldlevel=0:tabstop=4:shiftwidth=4:softtabstop=0:noexpandtab
