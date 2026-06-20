-----------------------
---- LOOK AND FEEL ----
-----------------------

local colors = require("colors")

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 7,
		gaps_out = 7,

		border_size = 3,

		col = {
			active_border = { colors = { colors.primary }, angle = 45 },
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "scrolling",
	},

	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 1.0,
		direction = "right",
	},

	decoration = {
		rounding = 15,
		rounding_power = 3,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = false,
			range = 20,
			render_power = 3,
			color = 0xee121212,
		},

		blur = {
			enabled = true,
			size = 7,
			passes = 3,
			special = true,
			brightness = 0.60,
			contrast = 0.75,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "slidevert" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slidevert" })

-- Smart Gaps
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
-- hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
-- hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
-- hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })

hl.config({
	dwindle = {
		preserve_split = true,
		force_split = 2,
	},

	scrolling = {
		column_width = 0.49,
	},

	master = {
		new_status = "master",
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_scale_notification = true,
		focus_on_activate = true,
		anr_missed_pings = 3,
		on_focus_under_fullscreen = 1,
	},

	cursor = {
		hide_on_key_press = true,
		warp_on_change_workspace = 1,
	},

	binds = {
		hide_special_on_workspace_change = true,
	},
})
