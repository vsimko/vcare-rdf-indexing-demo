#!/bin/bash

# commandline args

FILE="$1"

# constants

MIME=`xdg-mime query filetype "$FILE"`
HOST="localhost"
PORT="8889"

# helper methods

echo_bold() {
    echo -e "\e[1m$@\e[0m"
}

echo_red() {
    echo -e "\e[31m$@\e[0m"
}

usage() {
    REASON="$1"
    [ -n "$REASON" ] && echo_red ERROR: $REASON
    echo_bold USAGE: $(basename $0) path/to/file.ttl
    exit 1
}

# checks

[ -z "$FILE" ] && usage "Filename is missing"

[ -z "$MIME" ] && usage "Could not determine mime type"

# program stats here

echo_bold "File to import: $FILE"
echo_bold "Detected mime type: $MIME"

curl -q -X POST \
    -H "Content-Type:$MIME" \
    --data-binary "@$FILE" \
    http://$HOST:$PORT/bigdata/sparql |
      grep -A 2 -B 2 --color=always \
      -e 'modified="[0-9]*"' \
      -e 'milliseconds="[0-9]*"' \
      -e 'Exception'
