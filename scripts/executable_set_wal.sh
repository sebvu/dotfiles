#!/bin/bash

CACHE_IMAGE="$(cat $HOME/.cache/swww/eDP-1)"

wal -i $CACHE_IMAGE &>/dev/null
