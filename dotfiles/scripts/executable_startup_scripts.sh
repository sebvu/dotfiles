#!/bin/bash

# Scripts started upon system boot

SCRIPTS="$HOME/scripts"

check_error () {
    if [ "$1" -ne 0 ]; then
        exec notify-send -t 5000 -r 4999 -u critical "Error on startup" "Exit code $1 on $2"
    fi
}

gammastep -l 30.210740:-95.4256170 -t 6500:3500 &

check_error $? 1

"$SCRIPTS"/bedtime.sh &

check_error $? 2

notify-send -t 5000 -r 4997 -u normal 'Successfully initialized startup scripts'

exit 0




