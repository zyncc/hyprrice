#!/bin/bash

option=$(printf "Install\nInstall WebApp\nRemove" | rofi -dmenu -p "Packages")

case "$option" in
    "Install") kitty --title floating-install-menu -e /home/zync/.config/scripts/pkg-install ;;
    "Install WebApp") kitty --title floating-install-menu -e /home/zync/.config/scripts/webapp-install ;;
    "Remove") kitty --title floating-install-menu -e /home/zync/.config/scripts/pkg-remove ;;
esac