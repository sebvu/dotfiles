#!/bin/bash

TRANSITION_TYPE="outer"

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Use rofi to select an image
SELECTED_IMAGE=$(ls ~/Pictures/wallpapers | while read A ; do  echo -en "$A\x00icon\x1f~/Pictures/wallpapers/$A\n"; done | rofi -dmenu -theme "$HOME"/.config/rofi/wallpaper-switcher.rasi)

# If an image was selected, set it as the wallpaper
if [ -n "$SELECTED_IMAGE" ]; then

    wal -i "$WALLPAPER_DIR/$SELECTED_IMAGE"

    pywal-discord
    pywalfox update

    swww img "$WALLPAPER_DIR/$SELECTED_IMAGE" \
        --transition-type $TRANSITION_TYPE \
        --transition-duration 2


    # swww img $WALLPAPER_DIR/$SELECTED_IMAGE \
#     --transition-bezier .43,1.19,.4 \
#     --transition-type=$TRANSITION_TYPE \
#     --transition-fps=60 \
#     --transition-duration=0.7 \
#     --transition-pos "$(hyprctl cursorpos)"


    convert "$WALLPAPER_DIR/$SELECTED_IMAGE" -blur 0x16 "$HOME/.cache/blurred_wallpaper.png"
fi
