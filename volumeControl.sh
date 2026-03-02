#!/bin/sh

read -r MUTED VOLUME <<EOF
$(pamixer --get-mute --get-volume)
EOF

case $1 in
    up)
        MUTED=false
        VOLUME=$((VOLUME + 2))
        pactl set-sink-mute @DEFAULT_SINK@ false
        ;;
    down)
        MUTED=false
        VOLUME=$((VOLUME - 2))
        pactl set-sink-mute @DEFAULT_SINK@ false
        ;;
    mute)
        if [ "$MUTED" = "true" ]; then
            MUTED=false
        else
            MUTED=true
        fi
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
esac

[ "$VOLUME" -gt 100 ] && VOLUME=100
[ "$VOLUME" -lt 0 ] && VOLUME=0
pactl set-sink-volume @DEFAULT_SINK@ "$VOLUME"%

pkill -RTMIN+1 dwmblocks

send_notification() {
    dunstify -r 5555 -t 1000 -h int:value:"$VOLUME" "Volume: $1" \
        --icon=/usr/share/icons/Papirus-Dark/16x16/actions/"$2"
}

if [ "$MUTED" = "true" ]; then
    VOLUME=0
    send_notification "muted" "audio-volume-muted.svg"
elif [ "$VOLUME" -lt 33 ]; then
    send_notification "$VOLUME"% "audio-volume-low.svg"
elif [ "$VOLUME" -lt 66 ]; then
    send_notification "$VOLUME"% "audio-volume-medium.svg"
else
    send_notification "$VOLUME"% "audio-volume-high.svg"
fi

