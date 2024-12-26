#!/bin/bash

# Restart all necessary services

killall waybar;waybar &

killall dunst;dunst &

killall hypridle;hypridle &

notify-send -t 5000 -r 5000 -u critical "Services Restarted" "Waybar, Dunst, Hypridle"
