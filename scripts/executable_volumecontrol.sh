#!/usr/bin/env bash

output () {
    SEND="dunstify -t 1000 -r 2000 -u normal -i "$HOME/.config/dunst/icons/vol/vol-$(echo "$3" | sed 's/%//').svg""
    SEND_MUTESTATUS="dunstify -t 1000 -r 2100 -u normal -i "$HOME/.config/dunst/icons/vol/speaker-$(echo "$2" | tr '[:upper:]' '[:lower:]').svg""
    SEND_SPEAKERSTATUS="dunstify -t 1000 -r 2200 -u normal -i "$HOME/.config/dunst/icons/vol/mic-$(echo "$2" | tr '[:upper:]' '[:lower:]').svg""

    case ${1} in 
        master)
            $SEND_MUTESTATUS "Volume Toggled $2"
            ;;
        volume)
            $SEND "Volume $2" "$3"
            ;;
        capture)
            if [ "${2}" = "ON" ]; then
                $SEND_SPEAKERSTATUS "Microphone $2"
            elif [ "${2}" = "OFF" ]; then
                $SEND_SPEAKERSTATUS "Microphone $2"
            fi
            ;;
        *)
            $SEND "Unknown input: $1"
            ;;
    esac
}

get_volume () {
   amixer get Master | grep -o '[0-9]*%' | head -n1
}

check_volume_direction () {
    if [ "${1}" = "i" ]; then
        output "volume" "UP" "$(get_volume)"
    elif [ "${1}" = "d" ]; then
        amixer set Master 5%-
        output "volume" "DOWN" "$(get_volume)"
    else 
        dunstify -t 2000 -r 2000 -u critical "ERROR WITH CHECK_VOLUME_DIRECTION" "4"
        exit 4
    fi
}

check_state () {
    if [ "${1}" = "a" ]; then
        STATE="master" # volume toggle
    elif [ "${1}" = "m" ]; then
        STATE="capture" # microphone toggle
    else 
        dunstify -t 2000 -r 2000 -u critical "ERROR WITH CHECK_STATE INPUT" "${STATE} 2"
        exit 2
    fi

    MEOW=$(amixer get ${STATE^} | tail -n1 | awk -F'[][]' '{print $4}')

    if [ "${MEOW}" = "on" ]; then
        amixer set ${STATE^} toggle 
        output ${STATE} "OFF"
    elif [ "${MEOW}" = "off" ]; then
        amixer set ${STATE^} toggle
        output ${STATE} "ON"
    else
        dunstify -t 2000 -r 2000 -u critical "ERROR WITH CHECK_STATE INPUT" "${STATE} 3"
        exit 3
    fi
}

# Volume controlscript

case ${1} in
    i)
        check_volume_direction i 
        ;;
    d)
        check_volume_direction d
        ;;
    a)
        check_state a
        ;;
    m)
        check_state m
        ;;
    *) 
        dunstify -t 2000 -r 2000 -u critical "ERROR INPUT WITH VOLUMECONTROL.SH" "1"
        exit 1
esac

exit 0
