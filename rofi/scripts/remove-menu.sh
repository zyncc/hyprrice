#!/bin/bash

option=$(printf "AUR\nWebapp" | rofi -dmenu -p "Remove" --config /home/zync/.config/rofi/config.rasi -theme /home/zync/.config/rofi/no-icons-config.rasi)

case "$option" in
"AUR") kitty --title floating-install-menu -e /home/zync/.config/scripts/pkg-remove ;;
"Webapp") kitty --title floating-install-menu -e /home/zync/.config/scripts/webapp-remove ;;
esac
