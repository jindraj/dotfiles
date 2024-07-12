#!/usr/bin/env bash

# required notmuch config:
# [index]
# header.GitLabProjectPath=X-GitLab-Project-Path
# header.GitLabPipelineRef=X-GitLab-Project-Ref
# header.GitLabMergeRequestIID=X-GitLab-MergeRequest-IID

read -r -p 'Enter search term: ' my_nm_query
printf 'push "<vfolder-from-query>GitLabPipelineRef:%s OR GitLabProjectPath:%s OR GitLabMergeRequestIID:%s OR subject:%s<enter>"' "$my_nm_query" "$my_nm_query" "$my_nm_query" "$my_nm_query"
 
