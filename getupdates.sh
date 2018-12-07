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

base_url="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}"

curl() {
  local url="$1"
  shift

  tempfile="$(mktemp)"
  if ! command curl -LsS "${base_url}/$url" "$@" -o "$tempfile"; then
    echo "curl failed with following output:" >&2
    cat "$tempfile"
    rm -f "$tempfile"
  fi

  echo "$tempfile"
}

output_json() {
  local result_file="$1"
  shift

  echo "/* $(date -R) */"
  if [ $has_python -eq 1 ]; then
    python -m json.tool < "$result_file"
  else
    cat "$result_file"
  fi

  rm -f "$result_file"
}

get_me() {
  result_file="$(curl getMe)"
  output_json "$result_file"
  echo
}

get_updates() {
  url="${base_url}/getUpdates"
  curlopts=()

  if [ -n "$last_update_id" ]; then
    curlopts+=(--data-urlencode "offset=${last_update_id}")
  fi
  if [ $long_polling -eq 1 ]; then
    curlopts+=(--data-urlencode "timeout=300")
  fi

  result_file="$(curl getUpdates "${curlopts[@]}")"

  if [ $long_polling -eq 1 ]; then
    if [ "$(jq '.result | length' "$result_file")" -gt 0 ] && last_update_id="$(jq ".result[-1].update_id" "$result_file")"; then
      ((last_update_id++))
    fi
  fi

  output_json "$result_file"
}

get_me

get_updates

while [ "$long_polling" -eq 1 ]; do
  get_updates
done

# vi: ts=2 sw=2 expandtab
