#!/bin/bash

# Pull current brightness
get_brightness() {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

# Send notification
send_notification() {
    brightness=$(get_brightness)
    dunstify -i "$HOME/.config/dunst/icons/brightness-$1.png" -t 1000 -r 2593 -u normal "Brightness $(echo "$1" | tr '[:lower:]' '[:upper:]')" "${brightness}%"
}

# Error sent
print_error() {
    dunstify -t 2000 -r 2593 -u critical "Error: Invalid argument for Brightness"
}


case $1 in
    i)  # increase the backlight
        brightnessctl set +5%
        send_notification up
        ;;
    d)  # decrease the backlight
        if [[ $(get_brightness) -le 5 ]] ; then
            # avoid 0% brightness
            brightnessctl set 5%
        else
            # decrease the backlight by 5% otherwise
            brightnessctl set 5%-
        fi
        send_notification down
        ;;
    *)
        print_error
        exit 0
        ;;
esac

exit 1
