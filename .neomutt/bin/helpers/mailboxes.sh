#!/usr/bin/env bash

# required notmuch config:
# [index]
# header.GitLabProjectPath=X-GitLab-Project-Path

while read -r
do
	printf 'named-mailboxes "git/%s" "notmuch://?query=GitLabProjectPath:%s AND is:inbox" \n' "$REPLY" "$REPLY"
done < <(find "$HOME/cklb" -type d -execdir test -d {}/.git \; -prune -print | cut -f 6- -d / | grep -v _)
# grep -v _ - to prune git repositories with underscores (my local testing repos)
