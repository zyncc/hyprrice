#!/bin/bash

option=$(printf "󰀻  Apps\n󰏘  Style\n  Setup\n  Install\n  Remove\n  System" | rofi -dmenu -i -p "Menu")

case "$option" in
"󰀻  Apps") rofi -show drun -i -no-levenshtein-sort -disable-history -sort ;;
"󰏘  Style") "/home/zync/.config/rofi/scripts/theme-menu.sh" ;;
"  Setup") "/home/zync/.config/rofi/scripts/config.sh" ;;
"  Install") "/home/zync/.config/rofi/scripts/packages.sh" ;;
"  Remove") "/home/zync/.config/rofi/scripts/packages.sh" ;;
"  System") "/home/zync/.config/rofi/scripts/power-menu.sh" ;;
esac

