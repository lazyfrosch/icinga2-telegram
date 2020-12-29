#!/bin/sh
if [ -n "$ICINGAWEB2_URL" ]; then
    HOSTDISPLAYNAME="<a href=\"$ICINGAWEB2_URL/monitoring/host/show?host=$HOSTNAME\">$HOSTDISPLAYNAME</a>"
    SERVICEDISPLAYNAME="<a href=\"$ICINGAWEB2_URL/monitoring/service/show?host=$HOSTNAME&service=$SERVICEDESC\">$SERVICEDISPLAYNAME</a>"
fi
SERVICEOUTPUT_ESCAPED=$(echo $SERVICEOUTPUT | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g')
template=$(cat <<TEMPLATE
<strong>$NOTIFICATIONTYPE</strong> $HOSTDISPLAYNAME - $SERVICEDISPLAYNAME is $SERVICESTATE

Address: $HOSTADDRESS
Date/Time: $LONGDATETIME

<pre>$SERVICEOUTPUT_ESCAPED</pre>
TEMPLATE
)

if [ -n "$NOTIFICATIONCOMMENT" ]; then
  template="$template

Comment: ($NOTIFICATIONAUTHORNAME) $NOTIFICATIONCOMMENT
"
fi

/usr/bin/curl --silent --output /dev/null \
    --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
    --data-urlencode "text=${template}" \
    --data-urlencode "parse_mode=HTML" \
    --data-urlencode "disable_web_page_preview=true" \
    "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"
