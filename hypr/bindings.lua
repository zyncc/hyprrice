---------------------
---- KEYBINDINGS ----
---------------------

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + W", hl.dsp.window.close())

hl.bind(
	"SUPER + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

hl.bind("SUPER + SHIFT + SPACE", hl.dsp.exec_cmd("/home/zync/.config/scripts/toggle-waybar"))

-- TUIs
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("kitty -e nvim"))
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("kitty --title floating-btop -e btop"))
hl.bind("SUPER + CTRL + D", hl.dsp.exec_cmd("kitty --title floating-lazydocker -e lazydocker"))
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("kitty --title floating-bluetui -e bluetui"))
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd("kitty --title floating-wiremix -e wiremix"))

-- Rofi Menu
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd("/home/zync/.config/rofi/scripts/main-menu.sh"))
hl.bind("SUPER + CTRL + SHIFT + SPACE", hl.dsp.exec_cmd("/home/zync/.config/rofi/scripts/theme-menu.sh"))
hl.bind("SUPER + CTRL + SPACE", hl.dsp.exec_cmd("/home/zync/.config/rofi/scripts/wallpaper-menu.sh"))

-- Applications
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("$HOME/.config/scripts/launch-webapp 'https://chatgpt.com'"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("chromium"))
hl.bind("SUPER + SHIFT + Y", hl.dsp.exec_cmd("$HOME/.config/scripts/launch-webapp 'https://music.youtube.com'"))
hl.bind("SUPER + E", hl.dsp.exec_cmd('kitty zsh -ci "y; exec zsh"'))
hl.bind("SUPER + R", hl.dsp.exec_cmd("/home/zync/.config/waybar/scripts/launch.sh"))
hl.bind("SUPER + Space", hl.dsp.exec_cmd("rofi -show drun -i -no-levenshtein-sort -disable-history -sort"))

hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a -f 'hex' -n"))
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("/home/zync/.config/rofi/scripts/system-menu.sh"))
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))
hl.bind(
	"SUPER + CTRL + V",
	hl.dsp.exec_cmd(
		"cliphist list | rofi -dmenu -i -p 'Search Clipboard' -display-columns 2 | cliphist decode | wl-copy"
	)
)
-- Toggle Hyprland Layout
-- local current_layout = "dwindle"
-- -- hl.bind("SUPER + L", function()
-- 	current_layout = current_layout == "dwindle" and "scrolling" or "dwindle"
--
-- 	hl.config({
-- 		general = {
-- 			layout = current_layout,
-- 		},
-- 	})
-- end)

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --freeze --clipboard-only"))
hl.bind(
	"SUPER + Print",
	hl.dsp.exec_cmd("hyprshot -m region --freeze --raw | satty --config $HOME/.config/satty/config.toml --filename -")
)

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)

hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("$HOME/.config/scripts/audio-output-switch"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
