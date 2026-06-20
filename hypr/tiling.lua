---------------------
---- TILING ----
---------------------

hl.bind("SUPER + W", hl.dsp.window.close())
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))
hl.bind("SUPER + CTRL + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 0 }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + UP", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "d" }))

for workspace = 1, 10 do
	local key = "code:" .. tostring(workspace + 9)
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(workspace) }))
	hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace) }))
	hl.bind("SUPER + SHIFT + ALT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end

hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

hl.bind("SUPER + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Alt+Tab (standard MRU)
hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next --mod alt"))
hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd("snappy-switcher prev --mod alt"))

hl.bind("SUPER + SHIFT + ALT + LEFT", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind("SUPER + SHIFT + ALT + RIGHT", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind("SUPER + SHIFT + ALT + UP", hl.dsp.workspace.move({ monitor = "u" }))
hl.bind("SUPER + SHIFT + ALT + DOWN", hl.dsp.workspace.move({ monitor = "d" }))

hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.swap({ direction = "l" }))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "r" }))
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.swap({ direction = "u" }))
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.swap({ direction = "d" }))

-- hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))
-- hl.bind("ALT + SHIFT + TAB", hl.dsp.window.bring_to_top())

hl.bind("CTRL + ALT + TAB", hl.dsp.focus({ monitor = "+1" }))
hl.bind("CTRL + ALT + SHIFT + TAB", hl.dsp.focus({ monitor = "-1" }))

hl.bind("SUPER + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind("SUPER + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind("SUPER + SHIFT + code:20", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
hl.bind("SUPER + SHIFT + code:21", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))

hl.bind("SUPER + ALT + code:20", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
hl.bind("SUPER + ALT + code:21", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
hl.bind("SUPER + SHIFT + ALT + code:20", hl.dsp.window.resize({ x = 0, y = -25, relative = true }))
hl.bind("SUPER + SHIFT + ALT + code:21", hl.dsp.window.resize({ x = 0, y = 25, relative = true }))

hl.bind("SUPER + CTRL + code:20", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))
hl.bind("SUPER + CTRL + code:21", hl.dsp.window.resize({ x = 300, y = 0, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + code:20", hl.dsp.window.resize({ x = 0, y = -300, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + code:21", hl.dsp.window.resize({ x = 0, y = 300, relative = true }))

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + ALT + G", hl.dsp.window.move({ out_of_group = true }))

hl.bind("SUPER + ALT + LEFT", hl.dsp.window.move({ into_group = "l" }))
hl.bind("SUPER + ALT + RIGHT", hl.dsp.window.move({ into_group = "r" }))
hl.bind("SUPER + ALT + UP", hl.dsp.window.move({ into_group = "u" }))
hl.bind("SUPER + ALT + DOWN", hl.dsp.window.move({ into_group = "d" }))

hl.bind("SUPER + ALT + TAB", hl.dsp.group.next())
hl.bind("SUPER + ALT + SHIFT + TAB", hl.dsp.group.prev())

hl.bind("SUPER + CTRL + LEFT", hl.dsp.group.prev())
hl.bind("SUPER + CTRL + RIGHT", hl.dsp.group.next())

hl.bind("SUPER + ALT + mouse_down", hl.dsp.group.next())
hl.bind("SUPER + ALT + mouse_up", hl.dsp.group.prev())

for index = 1, 5 do
	hl.bind("SUPER + ALT + code:" .. tostring(index + 9) .. index, hl.dsp.group.active({ index = index }))
end
