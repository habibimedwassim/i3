#!/bin/bash
# Improved i3blocks volume blocklet using pactl

USE_TEXT_ICONS="true"
SINK=$(pactl get-default-sink)
I3BLOCKS_SIGNAL=10

if [ "$USE_TEXT_ICONS" = "true" ]; then
    ICON_HIGH=" "
    ICON_MID=" "
    ICON_LOW=" "
    ICON_MUTE=" "
else
    ICON_HIGH="墳"
    ICON_MID="奔"
    ICON_LOW="奄"
    ICON_MUTE="ﱝ"
fi

# Handle mouse events (scroll and click)
if [[ -n "$BLOCK_BUTTON" ]]; then
    case $BLOCK_BUTTON in
        1) pactl set-sink-mute "$SINK" toggle ;;
        4) pactl set-sink-volume "$SINK" +5% ;;
        5) pactl set-sink-volume "$SINK" -5% ;;
    esac

    # Get updated volume and mute after the change
    MUTE_STATUS=$(pactl get-sink-mute "$SINK" | awk '{print $2}')
    VOLUME=$(pactl get-sink-volume "$SINK" | awk 'NR==1 {print $5}' | tr -d '%')

    if [ "$MUTE_STATUS" = "yes" ]; then
        ICON="$ICON_MUTE"
        COLOR="#e06c75"
        VOL_DISPLAY="MUTED"
    elif [ "$VOLUME" -ge 66 ]; then
        ICON="$ICON_HIGH"
        COLOR="#98c379"
        VOL_DISPLAY="$VOLUME%"
    elif [ "$VOLUME" -ge 33 ]; then
        ICON="$ICON_MID"
        COLOR="#56b6c2"
        VOL_DISPLAY="$VOLUME%"
    else
        ICON="$ICON_LOW"
        COLOR="#d19a66"
        VOL_DISPLAY="$VOLUME%"
    fi

    echo "$ICON $VOL_DISPLAY"
    echo "$ICON $VOL_DISPLAY"
    echo "$COLOR"

    # Tell i3blocks to update again
    pkill -RTMIN+$I3BLOCKS_SIGNAL i3blocks
    exit 0
fi

# Get mute status
MUTE_STATUS=$(pactl get-sink-mute "$SINK" | awk '{print $2}')
# Get volume percentage reliably (take first volume if multiple channels)
VOLUME=$(pactl get-sink-volume "$SINK" | awk 'NR==1 {print $5}' | tr -d '%')

# Determine icon and color
if [ "$MUTE_STATUS" = "yes" ]; then
    ICON="$ICON_MUTE"
    COLOR="#e06c75"  # red for muted
elif [ "$VOLUME" -ge 66 ]; then
    ICON="$ICON_HIGH"
    COLOR="#98c379"  # green
elif [ "$VOLUME" -ge 33 ]; then
    ICON="$ICON_MID"
    COLOR="#56b6c2"  # cyan
else
    ICON="$ICON_LOW"
    COLOR="#d19a66"  # yellow
fi

# Output for i3blocks
echo "$ICON $VOLUME%"
echo "$ICON $VOLUME%"
echo "$COLOR"

