#!/bin/bash

# Usage: ./change-colors.sh [color-scheme-name]

COLOR_SCHEME=$1
COLOR_FILE="$HOME/.config/i3/colors/${COLOR_SCHEME}.i3colors"
CONFIG_FILE="$HOME/.config/i3/config"

# Check if the color scheme and config files exist
if [ ! -f "$COLOR_FILE" ]; then
    echo "Color scheme file does not exist."
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file does not exist."
    exit 1
fi

# Create a backup of the current config before making changes
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Replace the color scheme section
awk -v file="$COLOR_FILE" '
BEGIN { skip=0 }
/# Color Scheme Section Start/ { skip=1; print; system("cat " file); next }
/# Color Scheme Section End/ { skip=0; print; next }
!skip { print }
' "$CONFIG_FILE" > temp && mv temp "$CONFIG_FILE"

# Reload i3 configuration
i3-msg reload

echo "Colors changed to $COLOR_SCHEME and i3 reloaded."
