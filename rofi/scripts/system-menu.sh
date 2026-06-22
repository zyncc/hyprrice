#!/bin/bash

option=$(printf "Shutdown\nSleep\nRestart\nLock\nLogout" | rofi -dmenu -i -p "Power Options" --config /home/zync/.config/rofi/config.rasi -theme /home/zync/.config/rofi/no-icons-config.rasi)

case "$option" in
"Shutdown") hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0' ;;
"Sleep") systemctl suspend ;;
"Restart") hyprshutdown -t 'Restarting...' --post-cmd 'reboot' ;;
"Lock") hyprlock ;;
"Logout") uwsm stop ;;
esac
