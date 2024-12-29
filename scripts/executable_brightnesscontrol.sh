#!/bin/bash

# Pull current brightness
get_brightness() {
    brightnessctl -m | grep -oP '\d+(?=)%' | head -c-2 
}

# Send notification
send_notification() {
    brightness=$(get_brightness)
    dunstify -i "$HOME/.config/dunst/icons/vol/vol-${brightness}.svg" -t 1000 -r 2593 -u normal "Brightness $(echo "$1" | tr '[:lower:]' '[:upper:]')" "${brightness}%"
}

# Error sent
print_error() {
    dunstify -t 2000 -r 2593 -u critical "Error: Invalid argument for Brightness"
}


case $1 in
    i)  # increase the backlight
        brightness=$(get_brightness)
        # dunstify ${brightness}
        increment_amount=$(( 5 - (brightness % 5) ))

        brightnessctl set ${increment_amount}%+
        send_notification up
        ;;
    d)  # decrease the backlight
        if [[ $(get_brightness) -le 5 ]] ; then
            # avoid 0% brightness
            brightnessctl set 5%
        else
            # decrease the backlight by 5% otherwise
            brightness=$(get_brightness)
            increment_amount=$(( brightness % 5 ))
            if [[ ${increment_amount} -eq 0 ]] ; then
                brightnessctl set 5%-
            else
                brightnessctl set ${increment_amount}%-
            fi
        fi
        send_notification down
        ;;
    *)
        print_error
        exit 0
        ;;
esac

exit 1
