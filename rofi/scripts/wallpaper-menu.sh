#!/bin/bash

THEME_DIR="$HOME/.config/themes"
CURRENT_THEME_FILE="$THEME_DIR/.current_theme"

[ ! -f "$CURRENT_THEME_FILE" ] && {
    notify-send "Wallpaper Switcher" "No theme selected"
    exit 1
}

theme=$(cat "$CURRENT_THEME_FILE")
wallpaper_dir="$THEME_DIR/$theme/wallpapers"

[ ! -d "$wallpaper_dir" ] && {
    notify-send "Wallpaper Switcher" "Wallpaper folder not found"
    exit 1
}

selected=$(find "$wallpaper_dir" -maxdepth 1 -type f \
    \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) \
    | while read -r img; do
        printf "%s\x00icon\x1f%s\n" "$(basename "$img")" "$img"
    done | rofi -dmenu -show-icons -p "Wallpapers" -theme /home/zync/.config/rofi/wallpaper-menu.rasi)

[ -z "$selected" ] && exit

wallpaper="$wallpaper_dir/$selected"

matugen image "$wallpaper" --source-color-index 0