" Vim filetype detection file
"
" Language:     OpenSSH known_hosts (known_hosts)
" Author:       Camille Moncelier <moncelier@devlife.org>
" Copyright:    Copyright (C) 2010 Camille Moncelier <moncelier@devlife.org>
" Licence:      You may redistribute this under the same terms as Vim itself
"
" This sets up the syntax highlighting for known_host file

if &compatible || version < 600
    finish
endif

" Known_hosts
au BufNewFile,BufRead known_hosts set filetype=known_hosts
