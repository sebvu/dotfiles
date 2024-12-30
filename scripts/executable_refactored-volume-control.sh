#!/usr/bin/env bash

# helper function
get_volume () {
    amixer get Master | grep -oP '[0-9]\d(?=%)' | head -n1
}

# output function
# ($1) type vol/mic
# ($2) status #|on/off
output () {
    ICONS="$HOME/.config/dunst/icons/vol/"
    SEND="dunstify -t 1000 -r 2000 -u normal -i "${ICONS}${1}-${2}.svg""
    case ${1} in
        vol)
            ${SEND} "Volume: $2"
            ;;
        mic)
            ${SEND} "Mic: $2"
            ;;
        *)
            dunstify -t 2000 -r 2100 -u critical "Output received invalid code." "err 3"
            exit 3
    esac
}

# for volume decrease/increase
volume_change_handler () {
    if [[ "${1}" = "i" ]] ; then
        # set to closest upper multiple of 5
        echo "bruh"
        curr_vol=$(get_volume)
        increment_value=$(( 5 - (curr_vol % 5) ))
        amixer set Master ${increment_value}%+
    elif [[ "${1}" = "d" ]] ; then
        curr_vol=$(get_volume)
        if [[ $(( curr_vol % 5 )) -eq 0 ]] ; then
            # normal increase of 5
            echo "whoops"
            amixer set Master 5%-
        else
            echo "yaa"
            # set to closest lower multiple of 5
            increment_value=$(( curr_vol % 5 ))
            amixer set Master ${increment_value}%-
        fi
    else
        dunstify -t 2000 -r 2100 -u critical "Volume change handle received invalid code" "err 2"
        exit 2
    fi

    output "vol" "$(get_volume)"
}

# for audio and microphone mute/unmute
toggle_handler () {
    # get state
    # (master) volume state
    # (capture) mic state
    if [[ "${1}" = "a" ]] ; then
        TYPE="vol"
        STATE="master"
    elif [[ "${1}" = "m" ]] ; then
        TYPE="mic"
        STATE="capture"
    else
        dunstify -t 2000 -r 2100 -u critical "State was not properly caught." "err 4"
        exit 4
    fi

    STATUS=$(amixer get ${STATE^} | grep -oP 'on|off' | tail -n1)

    if [[ "${STATUS}" = "on" ]] ; then
        amixer set ${STATE^} toggle
        output ${TYPE} "off"
    elif [[ "${STATUS}" = "off" ]] ; then
        amixer set ${STATE^} toggle
        output ${TYPE} "on"
    else
        dunstify -t 2000 -r 2100 -u critical "Could not check status of state ${STATE^}" "err 5"
        exit 5
    fi
}

case ${1} in
# (i) increase volume
# (d) decrease volume
# (a) audio mute/unmute
# (m) microphone mute/unmute
# (*) not a valid code
    i)  
        volume_change_handler "i" 
        ;;
    d)
        volume_change_handler "d"
        ;;
    a) 
        toggle_handler "a"
        ;;
    m) 
        toggle_handler "m"
        ;;
    *)
        dunstify -t 2000 -r 2100 -u critical "Not a valid case for volume control." "err 1"
        exit 1
        ;;
esac

exit 0
