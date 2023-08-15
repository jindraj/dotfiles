#!/usr/bin/env bash
if ! command -v a2ps >/dev/null || ! command -v ps2pdf >/dev/null; then
    echo "ERROR: both a2ps and ghostscript must be installed" 1>&2
    exit 1
fi

tmpfile=$(mktemp)
perl -pe 's/\e\[[\d;]*m//g;'            | \
	iconv -f utf-8 -t iso-8859-2 -c | \
	a2ps -B -X iso2 -o -            | \
	ps2pdf - "$tmpfile"

# a2ps brew build needs a little fixing: https://github.com/orgs/Homebrew/discussions/4531#discussioncomment-6009690
# a2ps can be replaced with enscript
# enscript -f Courier8 -X latin2 -B $INPUT -p - 2>/dev/null

open -a Preview "$tmpfile"
sleep 1
rm "$tmpfile"
