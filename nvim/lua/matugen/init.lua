-- matugen.nvim — Material You wallpaper-adaptive colorscheme for Neovim
-- Reads colors from matugen and derives a full editor theme using OKLCH color science

local palette_mod = require("matugen.palette")
local highlights = require("matugen.highlights")

local M = {}

M._config = {
    colors_path = "~/.config/matugen/colors.json",
    harmonize = 15,
    min_contrast = 0.45,
    brightness = 0.03,
    contrast = 0,
    sidebar_brightness = 0.02,
    transparent = false,
    overrides = {},
    watch = true, -- auto-reload when colors_path changes (e.g. wallpaper switch)
}

M._palette = nil
M._watcher = nil

--- Watch colors_path for changes and auto-reload. Watches the parent
--- directory so the watch survives matugen rename-into-place writes.
local function start_watch()
    local uv = vim.uv or vim.loop
    if M._watcher then return end

    local target = vim.fn.expand(M._config.colors_path)
    local dir = vim.fs.dirname(target)
    local base = vim.fs.basename(target)
    if vim.fn.isdirectory(dir) == 0 then return end

    local handle = uv.new_fs_event()
    if not handle then return end

    local timer = uv.new_timer()
    local function schedule_reload()
        timer:stop()
        timer:start(150, 0, vim.schedule_wrap(function()
            M.load()
        end))
    end

    local ok = handle:start(dir, {}, function(err, filename, _events)
        if err then return end
        if filename == base then schedule_reload() end
    end)
    if not ok then
        handle:close()
        return
    end

    M._watcher = { handle = handle, timer = timer }

    vim.api.nvim_create_autocmd("VimLeavePre", {
        once = true,
        callback = function()
            if M._watcher then
                if not M._watcher.handle:is_closing() then M._watcher.handle:close() end
                if not M._watcher.timer:is_closing() then M._watcher.timer:close() end
                M._watcher = nil
            end
        end,
    })
end

---@param opts table|nil
function M.setup(opts)
    M._config = vim.tbl_deep_extend("force", M._config, opts or {})

    vim.api.nvim_create_user_command("MatugenReload", function()
        M.load()
        vim.notify("matugen.nvim: reloaded", vim.log.levels.INFO)
    end, { desc = "Reload matugen colorscheme from current colors" })

    vim.api.nvim_create_user_command("MatugenWatch", function(cmd)
        if cmd.args == "off" then
            if M._watcher then
                if not M._watcher.handle:is_closing() then M._watcher.handle:close() end
                if not M._watcher.timer:is_closing() then M._watcher.timer:close() end
                M._watcher = nil
            end
            vim.notify("matugen: watcher off", vim.log.levels.INFO)
        else
            start_watch()
            vim.notify("matugen: watcher " .. (M._watcher and "on" or "failed to start"), vim.log.levels.INFO)
        end
    end, { nargs = "?", complete = function() return { "on", "off" } end, desc = "Toggle matugen colors.json watcher" })

    if M._config.watch then start_watch() end

    vim.api.nvim_create_user_command("MatugenBrightness", function(cmd)
        local val = tonumber(cmd.args)
        if not val then
            vim.notify("matugen brightness: " .. M._config.brightness, vim.log.levels.INFO)
            return
        end
        M._config.brightness = val
        M.load()
        vim.notify(string.format("matugen brightness: %.2f", val), vim.log.levels.INFO)
    end, { nargs = "?", desc = "Get/set OKLCH brightness offset (-0.10 to +0.15)" })

    vim.api.nvim_create_user_command("MatugenContrast", function(cmd)
        local val = tonumber(cmd.args)
        if not val then
            vim.notify("matugen contrast: " .. M._config.contrast, vim.log.levels.INFO)
            return
        end
        M._config.contrast = val
        M.load()
        vim.notify(string.format("matugen contrast: %.2f", val), vim.log.levels.INFO)
    end, { nargs = "?", desc = "Get/set OKLCH contrast offset (-0.10 to +0.10)" })
end

--- Load the colorscheme: read matugen JSON, derive palette, apply highlights.
--- If the JSON file is missing or unreadable, falls back to the MD3 baseline
--- so the colorscheme still loads — the user just doesn't get wallpaper colors
--- until matugen is set up.
function M.load()
    local mc = palette_mod.read_colors(M._config.colors_path)
    if not mc then
        vim.notify(
            "matugen.nvim: could not read " .. M._config.colors_path
            .. "\nFalling back to baseline palette. See README to set up matugen.",
            vim.log.levels.WARN
        )
    end

    local ok, pal = pcall(palette_mod.derive, mc, {
        harmonize = M._config.harmonize,
        min_contrast = M._config.min_contrast,
        brightness = M._config.brightness,
        contrast = M._config.contrast,
        sidebar_brightness = M._config.sidebar_brightness,
    })
    if not ok then
        vim.notify(
            "matugen.nvim: palette derivation failed: " .. tostring(pal)
            .. "\nFalling back to baseline palette.",
            vim.log.levels.ERROR
        )
        pal = palette_mod.derive(nil, {})
    end

    -- Apply user overrides
    if M._config.overrides and next(M._config.overrides) then
        pal = vim.tbl_extend("force", pal, M._config.overrides)
    end

    -- pass transparent option into the palette so highlights can act on it
    pal.transparent = M._config.transparent
    M._palette = pal
    vim.g.colors_name = "matugen"
    highlights.apply(pal)
    vim.api.nvim_exec_autocmds("User", { pattern = "MatugenReloaded", modeline = false })
end

--- Get the current palette (after load). Useful for statusline/lualine integration.
---@return table|nil
function M.get_palette()
    return M._palette
end

--- Get the color module for external use (building your own palette, etc.)
function M.color()
    return require("matugen.color")
end

--- Build a lualine theme table from the current palette.
function M.lualine()
    local p = M._palette
    if not p then return "auto" end

    local function mode(accent)
        return {
            a = { fg = p.bg, bg = accent, gui = "bold" },
            b = { fg = accent, bg = p.base3 },
            c = { fg = p.fg_alt, bg = p.base1 },
        }
    end

    return {
        normal   = mode(p.accent),
        insert   = mode(p.green),
        visual   = mode(p.magenta),
        replace  = mode(p.red),
        command  = mode(p.orange),
        terminal = mode(p.cyan),
        inactive = {
            a = { fg = p.base6, bg = p.base2 },
            b = { fg = p.base6, bg = p.base1 },
            c = { fg = p.base5, bg = p.base0 },
        },
    }
end

return M
