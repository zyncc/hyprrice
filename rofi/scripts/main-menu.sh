#!/bin/bash

option=$(printf "󰀻  Apps\n󰏘  Style\n  Setup\n  Install\n  Remove\n  System" | rofi -dmenu -i -p "Menu" --config /home/zync/.config/rofi/config.rasi -theme /home/zync/.config/rofi/no-icons-config.rasi)

case "$option" in
"󰀻  Apps") rofi -show drun -i -no-levenshtein-sort -disable-history -sort ;;
"󰏘  Style") "/home/zync/.config/rofi/scripts/theme-menu.sh" ;;
"  Setup") "/home/zync/.config/rofi/scripts/config.sh" ;;
"  Install") "/home/zync/.config/rofi/scripts/install-menu.sh" ;;
"  Remove") "/home/zync/.config/rofi/scripts/remove-menu.sh" ;;
"  System") "/home/zync/.config/rofi/scripts/system-menu.sh" ;;
esac
