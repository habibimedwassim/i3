#!/bin/bash

# Usage: ./change-colors.sh [color-scheme-name]

COLOR_SCHEME=$1
COLOR_FILE="$HOME/.config/i3/colors/${COLOR_SCHEME}.i3colors"
CONFIG_FILE="$HOME/.config/i3/config"
I3BLOCKS_TEMPLATE="$HOME/.config/i3blocks/i3blocks.template"
I3BLOCKS_FILE="$HOME/.config/i3blocks/i3blocks.conf"
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"
ALACRITTY_THEME_DIR="$HOME/.config/alacritty/themes/"

# Check if the color scheme, config, and i3blocks template files exist
if [ ! -f "$COLOR_FILE" ]; then
    echo "Color scheme file does not exist."
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file does not exist."
    exit 1
fi

if [ ! -f "$I3BLOCKS_TEMPLATE" ]; then
    echo "i3blocks template file does not exist."
    exit 1
fi

if [ ! -f "${ALACRITTY_THEME_DIR}${COLOR_SCHEME}.toml" ]; then
    echo "Alacritty theme file does not exist."
    exit 1
fi

# Create backups of the current config before making changes
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"
cp "$I3BLOCKS_FILE" "${I3BLOCKS_FILE}.bak"
cp "$ALACRITTY_CONFIG" "${ALACRITTY_CONFIG}.bak"

# Copy the template to the actual config
cp "$I3BLOCKS_TEMPLATE" "$I3BLOCKS_FILE"

# Replace the color scheme section in i3 config
awk -v file="$COLOR_FILE" '
BEGIN { skip=0 }
/# Color Scheme Section Start/ { skip=1; print; system("cat " file); next }
/# Color Scheme Section End/ { skip=0; print; next }
!skip { print }
' "$CONFIG_FILE" > temp && mv temp "$CONFIG_FILE"

# Replace color variables in i3blocks config
awk -v file="$COLOR_FILE" '
BEGIN {
    while (getline < file > 0) {
        if ($1 == "set") {
            gsub("\\$", "", $2);
            color[$2] = $3;
        }
    }
}
{ 
    for (c in color) {
        gsub("\\$"c, color[c]);
    }
    print;
}' "$I3BLOCKS_FILE" > temp && mv temp "$I3BLOCKS_FILE"

# Update Alacritty config import
sed -i "s|import = .*|import = [\"${ALACRITTY_THEME_DIR}${COLOR_SCHEME}.toml\"]|" "$ALACRITTY_CONFIG"

# Reload i3 and i3blocks configurations
i3-msg reload
pkill -SIGUSR1 i3blocks

echo "Colors changed to $COLOR_SCHEME, i3 and i3blocks reloaded, and Alacritty theme updated."
