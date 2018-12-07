#!/bin/bash

set -e

TYPE="$1"

#export TELEGRAM_BOT_TOKEN="12345678:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

require_env() {
  if [ -z ${!1} ]; then
    echo "$1 must be set in environment!" >&2
    exit 1
  fi
  export "$1"
}

require_env TELEGRAM_BOT_TOKEN

has_python=0
has_jq=0
last_update_id=
long_polling=0

if command -v jq >/dev/null; then
  has_jq=1
  long_polling=1
fi
if command -v python >/dev/null; then
  has_python=1
fi

get_updates() {
  url="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getUpdates"
  curlopts=()

  if [ -n "$last_update_id" ]; then
    curlopts+=(--data-urlencode "offset=${last_update_id}")
  fi
  if [ $long_polling -eq 1 ]; then
    curlopts+=(--data-urlencode "timeout=300")
  fi

  tempfile="$(mktemp)"
  if ! curl -LsS "${curlopts[@]}" "$url" -o "$tempfile"; then
    echo "curl failed with following output:" >&2
    cat "$tempfile"
    rm -f "$tempfile"
  fi

  if [ $long_polling -eq 1 ]; then
    last_update_id="$(jq ".result[-1].update_id" "$tempfile")"
    ((last_update_id++))
  fi

  echo "/* $(date -R) */"
  if [ $has_python -eq 1 ]; then
    python -m json.tool < "$tempfile"
  else
    cat "$tempfile"
  fi
}

get_updates

while [ "$long_polling" -eq 1 ]; do
  get_updates
done

# vi: ts=2 sw=2 expandtab
