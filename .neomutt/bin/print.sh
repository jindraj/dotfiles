#!/usr/bin/env sh
INPUT="$1" OPEN_PDF="open -a Preview"

if ! command -v a2ps >/dev/null || ! command -v ps2pdf >/dev/null; then
    echo "ERROR: both enscript and ps2pdf must be installed" 1>&2
    exit 1
fi

tmpfile=$(mktemp)
perl -pe 's/\e\[[\d;]*m//g;' | \
	iconv -f utf-8 -t iso-8859-2 -c | \
	a2ps -B -X iso2 -o - | \
	ps2pdf - $tmpfile

#a2ps can be replaced with enscript
#enscript -f Courier8 -X latin2 -B $INPUT -p - 2>/dev/null

$OPEN_PDF $tmpfile
sleep 1
rm $tmpfile
