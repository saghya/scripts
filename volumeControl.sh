#!/bin/sh

VOLUME=$(pamixer --get-volume)

case $1 in
    up)
        pactl set-sink-mute @DEFAULT_SINK@ false
        VOLUME=$((VOLUME + 2)) ;;
    down)
        pactl set-sink-mute @DEFAULT_SINK@ false
        VOLUME=$((VOLUME - 2))
        pactl set-sink-volume @DEFAULT_SINK@ $VOLUME% ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
esac

[ $VOLUME -gt 100 ] && VOLUME=100
[ $VOLUME -lt 0 ] && VOLUME=0
pactl set-sink-volume @DEFAULT_SINK@ $VOLUME%

kill -35 "$(pidof dwmblocks)"

send_notification() {
    dunstify -r 5555 -t 1000 -h int:value:$VOLUME "Volume: $1" --icon=/usr/share/icons/Papirus-Dark/16x16/actions/"$2"
}

if pamixer --get-volume-human | grep -q "muted"; then
    VOLUME=0
    send_notification "muted" "audio-volume-low.svg"
elif [ $VOLUME -lt 33 ]; then
    send_notification $VOLUME% "audio-volume-low.svg"
elif [ $VOLUME -lt 66 ]; then
    send_notification $VOLUME% "audio-volume-medium.svg"
else
    send_notification $VOLUME% "audio-volume-high.svg"
fi

