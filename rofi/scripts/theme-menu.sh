#!/bin/bash

THEME_DIR="$HOME/.config/themes"
mode="dark"

if [ -f "$THEME_DIR/$theme/light.theme" ]; then
    mode="light"
fi

theme=$(find "$THEME_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
    | sort \
    | rofi -dmenu -p "Themes")

[ -z "$theme" ] && exit

echo "$theme" > ~/.config/themes/.current_theme

wallpaper=$(find "$THEME_DIR/$theme/wallpapers" \
    -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) \
    | sort \
    | head -n1)

[ -z "$wallpaper" ] && {
    notify-send "Theme Switcher" "No wallpapers found for $theme"
    exit 1
}

matugen image "$wallpaper" --source-color-index 0 -m "$mode"