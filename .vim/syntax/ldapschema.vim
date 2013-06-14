" Hyphens are allowed in keywords, so we'd better set them
setlocal iskeyword=A-Z,a-z,-

syntax case ignore

" A comment starts in # and proceeds to the end of the line
syntax region LDAPSchemaComment start="#" end="$"

" These two types of regions are bounded by a (bracketed) region
syntax region LDAPSchemaAttrType start="attributetype\_s\+(" end=")" contains=LDAPSchemaKeyAttrType,@LDAPSchemaStd,@LDAPSchemaAttr fold
syntax keyword LDAPSchemaKeyAttrType attributetype contained

syntax region LDAPSchemaObjClass start="objectclass\_s\+(" end=")" contains=LDAPSchemaKeyObjClass,@LDAPSchemaStd,@LDAPSchemaObj fold
syntax keyword LDAPSchemaKeyObjClass objectclass contained

syntax match LDAPSchemaObjIdent "objectidentifier\(\s\+\S\+\)\{2}" contains=LDAPSchemaKeyObjIdent
syntax keyword LDAPSchemaKeyObjIdent objectidentifier contained

syntax match LDAPSchemaMIB "[0-9]\+\(\.[0-9]\+\)*" contained

" A string is single-quoted and can't contain a single quote; i.e. the .*
" pattern is non-greedy
syntax match LDAPSchemaString "'.\{-}'" contained

" match 'NAME' then the next whitespace-separated token after it only
syntax match LDAPSchemaName "\<NAME\s\+\S\+" contained contains=LDAPSchemaStName,LDAPSchemaString
" match 'NAME' then a bracketd list
syntax match LDAPSchemaName "\<NAME\s\+(\_.\{-})" contained contains=LDAPSchemaStName,LDAPSchemaString,LDAPSchemaSep
syntax keyword LDAPSchemaStName NAME contained

" Similar...
syntax match LDAPSchemaDesc "\<DESC\s\+\S\+" contained contains=LDAPSchemaStDesc,LDAPSchemaString
syntax keyword LDAPSchemaStDesc DESC contained

syntax match LDAPSchemaEqOrdSub "\<\(EQUALITY\|ORDERING\|SUBSTR\)\s\+\S\+" contained contains=LDAPSchemaStEqOrdSub
syntax keyword LDAPSchemaStEqOrdSub EQUALITY ORDERING SUBSTR contained

syntax match LDAPSchemaSyn "\<SYNTAX\s\+\S\+" contained contains=LDAPSchemaStSyn,LDAPSchemaMIBWithLen
syntax keyword LDAPSchemaStSyn SYNTAX contained
syntax match LDAPSchemaMIBWithLen "[0-9]\+\(\.[0-9]\+\)*\({[0-9]\+}\)\?" contained contains=LDAPSchemaMIB,LDAPSchemaLength
syntax match LDAPSchemaLength "{[0-9]\+}" contained

syntax keyword LDAPSchemaStSingle SINGLE-VALUE contained

syntax match LDAPSchemaSup "\<SUP\s\+\S\+" contained contains=LDAPSchemaStSup,LDAPSchemaObjName
syntax match LDAPSchemaSup "\<SUP\s\+(\_.\{-})" contained contains=LDAPSchemaStSup,LDAPSchemaObjName,LDAPSchemaSep
syntax keyword LDAPSchemaStSup SUP contained

syntax keyword LDAPSchemaStStrAuxAb STRUCTURAL AUXILIARY ABSTRACT contained

" Atribute lists have also a bracketed region; shouldn't be newlines in here
syntax match LDAPSchemaObjAttrs "\<\(MAY\|MUST\)\s\+\S\+" contained contains=LDAPSchemaStMayMust
syntax match LDAPSchemaObjAttrs "\<\(MAY\|MUST\)\s\+(\_.\{-})" contained contains=LDAPSchemaStMayMust,LDAPSchemaSep
syntax keyword LDAPSchemaStMayMust MAY MUST contained

" Match the ( $ ) characters specially
" syntax region LDAPSchemaAttrList matchgroup=LDAPSchemaSep start="(" end=")" matchgroup=none contained contains=LDAPSchemaSep
syntax match LDAPSchemaSep "[()$]" contained

syntax cluster LDAPSchemaStd contains=LDAPSchemaMIB,LDAPSchemaName,LDAPSchemaDesc,LDAPSchemaSup
syntax cluster LDAPSchemaAttr contains=LDAPSchemaEqOrdSub,LDAPSchemaSyn,LDAPSchemaStSingle
syntax cluster LDAPSchemaObj contains=LDAPSchemaStStrAuxAb,LDAPSchemaObjAttrs

syntax sync minlines=50

if version >= 508 || !exists("did_ldapschema_syn_inits")
    if version < 508
	let did_ldapschema_syn_inits = 1
	command -nargs=+ HiLink hi link <args>
    else
	command -nargs=+ HiLink hi def link <args>
    endif

    HiLink LDAPSchemaKeyAttrType   LDAPSchemaKeyword
    HiLink LDAPSchemaKeyObjClass   LDAPSchemaKeyword
    HiLink LDAPSchemaKeyObjIdent   LDAPSchemaKeyword

    HiLink LDAPSchemaStName        LDAPSchemaStatement
    HiLink LDAPSchemaStDesc        LDAPSchemaStatement
    HiLink LDAPSchemaStEqOrdSub    LDAPSchemaStatement
    HiLink LDAPSchemaStSyn         LDAPSchemaStatement
    HiLink LDAPSchemaStSeq         LDAPSchemaStatement
    HiLink LDAPSchemaStSup         LDAPSchemaStatement
    HiLink LDAPSchemaStMayMust     LDAPSchemaStatement

    HiLink LDAPSchemaStSingle      LDAPSchemaFlag
    HiLink LDAPSchemaStStrAuxAb    LDAPSchemaFlag

    HiLink LDAPSchemaComment       Comment
    HiLink LDAPSchemaKeyword       Keyword
    HiLink LDAPSchemaStatement     Type
    HiLink LDAPSchemaMIB           Identifier
    HiLink LDAPSchemaString        String
    HiLink LDAPSchemaLength        PreProc
    HiLink LDAPSchemaFlag          Identifier
    HiLink LDAPSchemaSep           Special
    
    delcommand HiLink
endif

set foldmethod=syntax
set foldcolumn=2
