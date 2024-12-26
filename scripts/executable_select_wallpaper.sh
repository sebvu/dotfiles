#!/bin/bash

# TRANSITION_TYPE="wipe"
TRANSITION_TYPE="outer"
# TRANSITION_TYPE="random"

# Directory containing wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Use rofi to select an image
SELECTED_IMAGE=$(ls "$WALLPAPER_DIR" | rofi -dmenu -i -p "Select Wallpaper" -theme "$HOME"/.cache/wal/colors-rofi-dark.rasi)

# If an image was selected, set it as the wallpaper
if [ -n "$SELECTED_IMAGE" ]; then
    swww img "$WALLPAPER_DIR/$SELECTED_IMAGE" \
    --transition-type=$TRANSITION_TYPE \
    --transition-duration=2\

    # swww img $WALLPAPER_DIR/$SELECTED_IMAGE \
#     --transition-bezier .43,1.19,.4 \
#     --transition-type=$TRANSITION_TYPE \
#     --transition-fps=60 \
#     --transition-duration=0.7 \
#     --transition-pos "$(hyprctl cursorpos)"


    wal -i "$WALLPAPER_DIR/$SELECTED_IMAGE"
    convert "$WALLPAPER_DIR/$SELECTED_IMAGE" -blur 0x16 "$HOME/.cache/blurred_wallpaper.png"
fi
