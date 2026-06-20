--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule {
	name = "xwayland-video-bridge-fixes",
	match = {
		class = "xwaylandvideobridge"
	},
	no_initial_focus = true,
	no_focus = true,
	no_anim = true,
	no_blur = true,
	max_size = "1 1",
	opacity = 0.0
}


hl.window_rule({
	name = "floating-tools",
	match = {
		class = "kitty",
		title = "^floating-.*$",
	},

	float = true,
	center = true,
	size = "1200 800",
})
