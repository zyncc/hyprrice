#!/bin/bash

option=$(printf "Hyprland\nKitty\nWaybar\nSwayNC" | rofi -dmenu -p "Edit Config")

case "$option" in
    "Hyprland") kitty --hold nvim "/home/zync/.config/hypr/hyprland.lua" ;;
    "Kitty") kitty --hold nvim "/home/zync/.config/kitty/kitty.conf" ;;
    "Waybar") kitty --hold nvim "/home/zync/.config/waybar/config.jsonc" ;;
    "SwayNC") kitty --hold nvim "/home/zync/.config/swaync/config.json" ;;
esac