#!/bin/sh

REPLY=$( curl https://sport.uni-ulm.de/de/unifit/information --silent | grep "Checkins seit")

CHECKED_IN=$( echo "$REPLY" | grep -o '[0-9]*' | sed -n '2{p;q}' )
HOUR=$( echo "$REPLY" | grep -o '[0-9]*' | sed -n '3{p;q}' )

printf "$( date '+%Y-%m-%d %H:%M:%S'), %02d, %d \n" "$CHECKED_IN" "$HOUR"
