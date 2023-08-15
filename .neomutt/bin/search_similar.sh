#!/usr/bin/env bash

# to decode mime encoded headers
function __search_similar_decode_header(){
	python3 -c 'from email.header import decode_header, make_header; import sys; print(make_header(decode_header(sys.stdin.read())))'
}

function run(){
	# printf 'FORMAT' "extract headers using formail | decode mime headers | split words to lines | remove doublequotes | fzf | replace newlines with spaces"
	printf 'push "<vfolder-from-query>%s<enter>"' "$(formail -c -x Subject: -x From: -x To: < /dev/stdin | __search_similar_decode_header |tr ' ' '\n'| tr -d '"' | fzf -m --reverse | tr '\n' ' ')"
}

run "$@" >"$MY_TMP_SEARCH" 
