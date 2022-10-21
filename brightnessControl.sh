#!/bin/sh

BRIGHTNESS=$(xbacklight -get | cut -d '.' -f 1)

case $1 in
    up) BRIGHTNESS=$((BRIGHTNESS + 5)) ;;
    down) BRIGHTNESS=$((BRIGHTNESS - 5)) ;;
esac

[ "$BRIGHTNESS" -gt 100 ] && BRIGHTNESS=100
[ "$BRIGHTNESS" -lt 5 ] && BRIGHTNESS=5

xbacklight -set $BRIGHTNESS -time 0

dunstify -r 5555 -t 1000 -h int:value:$BRIGHTNESS "Brightness: $BRIGHTNESS%" --icon=/usr/share/icons/Papirus-Dark/16x16/actions/brightnesssettings.svg

