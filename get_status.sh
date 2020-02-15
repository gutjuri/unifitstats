#!/bin/sh

JSON_REPLY=$( curl https://sport.uni-ulm.de/unifitstatus --insecure --silent )

HOUR=$( echo "$JSON_REPLY" | grep -o '[0-9]*' | sed 1q )
CHECKED_IN=$( echo "$JSON_REPLY" | grep -o '[0-9]*' | sed -n '2{p;q}' )

printf "$( date '+%Y-%m-%d %H:%M:%S'), %02d, %d \n" "$CHECKED_IN" "$HOUR"
