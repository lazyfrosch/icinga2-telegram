#!/bin/bash

set -e

TYPE="$1"

#export TELEGRAM_BOT_TOKEN="12345678:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#export TELEGRAM_CHAT_ID="12366611"

require_env() {
  if [ -z ${!1} ]; then
    echo "$1 must be set in environment!" >&2
    exit 1
  fi
  export "$1"
}

require_env TELEGRAM_BOT_TOKEN
require_env TELEGRAM_CHAT_ID

export ICINGAWEB2_URL="${ICINGAWEB2_URL:-https://icinga.example.com/icingaweb2}"

if [ -z "$TYPE" ]; then
    echo "ARG1 must be set as type (host/service)" >&2
    exit 1
elif [ "$TYPE" = host ]; then
    export HOSTSTATE=DOWN
    export HOSTOUTPUT="Test host is not really reporting a problem!"

    script=./telegram-host-notification.sh
elif [ "$TYPE" = service ]; then
    export SERVICEDESC=testservice
    export SERVICESTATE=CRITICAL
    export SERVICEOUTPUT="Test service is not really reporting a problem!"
    export SERVICEDISPLAYNAME="testservice (example)"

    script=./telegram-service-notification.sh
else
    echo "You can only notify host or service!" >&2
    exit 1
fi

export NOTIFICATIONTYPE=Problem
export HOSTNAME=testhost
export HOSTALIAS=testhost.example.com
export HOSTDISPLAYNAME="testhost (example)"
export HOSTADDRESS=1.1.1.1
export LONGDATETIME="$(date)"
export NOTIFICATIONAUTHORNAME=icingaadmin
export NOTIFICATIONCOMMENT="No comment"

bash -x "$script"

# vi: ts=2 sw=2 expandtab
