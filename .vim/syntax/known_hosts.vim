" Vim syntax file
"
" Language:     OpenSSH known_hosts (known_hosts)
" Author:       Camille Moncelier <moncelier@devlife.org>
" Copyright:    Copyright (C) 2010 Camille Moncelier <moncelier@devlife.org>
" Licence:      You may redistribute this under the same terms as Vim itself
"
" This sets up the syntax highlighting for known_host file

" Setup
if version >= 600
    if exists("b:current_syntax")
        finish
    endif
else
    syntax clear
endif

if version >= 600
    setlocal iskeyword=_,-,a-z,A-Z,48-57
else
    set iskeyword=_,-,a-z,A-Z,48-57
endif

syn case ignore

syn keyword knownHostsKeyword ssh-rsa ssh-dsa
syn match   knownHostsHost    "^[^ ]\+" 
syn match   knownHostsKey     "[^ ]\+$"

" Define the default highlighting
if version >= 508 || !exists("did_known_hosts_syntax_inits")
    if version < 508
        let did_sshconfig_syntax_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink knownHostsKeyword Keyword
    HiLink knownHostsHost    Identifier
    HiLink knownHostsKey     String

    delcommand HiLink
endif

let b:current_syntax = "known_hosts"
