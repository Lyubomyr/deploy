#!/bin/sh

# set -u
# set -e

NAME=Monit
MONIT_URL=https://app.scale.pm/monit/
SLACK_URL=https://hooks.slack.com/services/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
CHANNEL="#errors"
EMOJI=:vertical_traffic_light:

/usr/bin/curl \
    -X POST \
    -s \
    --data-urlencode "payload={ \
        \"channel\": \"$CHANNEL\", \
        \"username\": \"$NAME\", \
        \"color\": \"danger\", \
        \"icon_emoji\": \"$EMOJI\", \
        \"pretext\": \"$MONIT_URL$MONIT_SERVICE $MONIT_DESCRIPTION\", \
        \"text\": \"$MONIT_EVENT\" \
    }" \
    $SLACK_URL
