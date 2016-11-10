#!/bin/sh
if [ -n "$ICINGAWEB2_URL" ]; then
    HOSTDISPLAYNAME="<a href=\"$ICINGAWEB2_URL/host/show?host=$HOSTNAME\">$HOSTDISPLAYNAME</a>"
fi
template=$(cat <<TEMPLATE
<strong>$NOTIFICATIONTYPE</strong> - $HOSTDISPLAYNAME is $HOSTSTATE

Host: $HOSTALIAS
Address: $HOSTADDRESS
Date/Time: $LONGDATETIME

<pre>$HOSTOUTPUT</pre>
TEMPLATE
)
if [ -n "$NOTIFICATIONCOMMENT" ]; then
"
Comment: ($NOTIFICATIONAUTHORNAME) $NOTIFICATIONCOMMENT
"
fi

/usr/bin/curl --silent --output /dev/null \
    --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
    --data-urlencode "text=${template}" \
    --data-urlencode "parse_mode=HTML" \
    --data-urlencode "disable_web_page_preview=true" \
    "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"
