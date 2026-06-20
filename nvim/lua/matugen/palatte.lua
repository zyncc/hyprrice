-- matugen.nvim — Palette derivation
-- Reads Material You tokens and derives a full editor palette using OKLCH
-- The background ramp comes directly from matugen's surface tokens (wallpaper-adaptive).
-- Accent colors are harmonized toward the wallpaper's primary hue.

local color = require("matugen.color")

local M = {}

-- Canonical hue angles for named accent slots (OKLCH degrees)
local ACCENT_HUES = {
    red     = 25,
    orange  = 55,
    yellow  = 90,
    green   = 145,
    teal    = 175,
    cyan    = 195,
    blue    = 250,
    violet  = 295,
    magenta = 345,
}

local ACCENT_NAMES = {
    "red", "orange", "yellow", "green", "teal", "cyan", "blue", "violet", "magenta",
}

local DEFAULTS = {
    harmonize = 15,
    min_contrast = 0.45,
    -- OKLCH lightness offset applied to all background/surface colors.
    brightness = 0,
    -- OKLCH lightness offset for accent/foreground colors (opposite direction from bg).
    -- Positive = more contrast (brighter accents on dark bg).
    contrast = 0,
    -- OKLCH lightness offset for sidebar panels (explorer, neo-tree, mini.files).
    -- Negative = darker than editor, positive = lighter. Applied on top of brightness.
    sidebar_brightness = 0.02,
}

-- Material 3 baseline dark scheme. Used when matugen JSON is missing or
-- when a template omits some keys — every key derive() reads is guaranteed
-- to resolve, and the baseline is a coherent MD3 palette on its own.
M.BASELINE_MC = {
    surface_container_lowest  = "#0f0d13",
    surface_dim               = "#141218",
    surface                   = "#1d1b20",
    surface_container_low     = "#1d1b20",
    surface_container         = "#211f26",
    surface_container_high    = "#2b292f",
    surface_container_highest = "#36343b",
    outline                   = "#938f99",
    outline_variant           = "#49454f",
    on_surface                = "#e6e0e9",
    on_surface_variant        = "#cac4d0",
    primary                   = "#d0bcff",
    secondary                 = "#ccc2dc",
    tertiary                  = "#efb8c8",
    error                     = "#f2b8b5",
}

--- Ensure three hues have at least min_dist angular separation.
local function spread_hues(h1, h2, h3, min_dist)
    min_dist = min_dist or 30
    local hues = { h1, h2, h3 }
    for _ = 1, 5 do
        for i = 1, 3 do
            for j = i + 1, 3 do
                local dist = color.hue_distance(hues[i], hues[j])
                if dist < min_dist then
                    local diff = ((hues[j] - hues[i] + 180) % 360) - 180
                    local push = (min_dist - dist) * 0.5
                    if diff >= 0 then
                        hues[i] = (hues[i] - push) % 360
                        hues[j] = (hues[j] + push) % 360
                    else
                        hues[i] = (hues[i] + push) % 360
                        hues[j] = (hues[j] - push) % 360
                    end
                end
            end
        end
    end
    return hues[1], hues[2], hues[3]
end

--- Read matugen colors from JSON file.
function M.read_colors(path)
    path = vim.fn.expand(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    local ok, data = pcall(vim.json.decode, content)
    if not ok then return nil end
    return data
end

--- Derive a complete editor palette from matugen color tokens.
--- The entire background ramp comes from matugen's surface system — it's already
--- wallpaper-tinted. Accents are derived from matugen's primary/secondary/tertiary
--- with OKLCH harmonization for the full color wheel.
--- Any key missing from `mc` is filled in from the MD3 baseline, so a partial
--- (or completely empty) JSON still produces a coherent palette.
---@param mc table|nil  matugen colors JSON, or nil for full baseline
---@param opts table|nil  override defaults
---@return table  palette ready for highlights.apply()
function M.derive(mc, opts)
    opts                = vim.tbl_extend("keep", opts or {}, DEFAULTS)
    mc                  = vim.tbl_extend("keep", mc or {}, M.BASELINE_MC)
    local pal           = {}

    -- ── Background ramp: directly from matugen surface tokens ──
    -- These are already wallpaper-tinted by Material You's color engine
    pal.base0           = mc.surface_container_lowest
    pal.base1           = mc.surface_dim
    pal.bg              = mc.surface
    pal.base2           = mc.surface_container_low
    pal.bg_alt          = mc.surface_container
    pal.base3           = mc.surface_container
    pal.base4           = mc.surface_container_high
    pal.base5           = mc.surface_container_highest

    -- Mid-tones: matugen's outline tokens bridge surfaces → text
    pal.base6           = mc.outline_variant
    pal.base7           = mc.outline
    pal.base8           = mc.on_surface_variant

    -- ── Foreground: directly from matugen ──
    pal.fg              = mc.on_surface
    pal.fg_alt          = mc.on_surface_variant

    -- Whether matugen handed us a light or dark scheme — picked up by
    -- highlights.apply() to set vim.o.background correctly.
    pal.bg_is_light     = color.hex_to_oklch(mc.surface).L > 0.5

    -- ── Muted text: halfway between outline and on_surface_variant ──
    -- Used for picker paths, secondary info, breadcrumbs — must be readable
    pal.muted           = color.scale_chroma(color.mix(mc.outline_variant, mc.outline, 0.5), 0.4)

    -- ── Highlight line: between bg and the next surface step ──
    pal.hl_line         = mc.surface_container_low

    -- ── Extract OKLCH of matugen accent colors ──
    local primary_lch   = color.hex_to_oklch(mc.primary)
    local secondary_lch = color.hex_to_oklch(mc.secondary)
    local tertiary_lch  = color.hex_to_oklch(mc.tertiary)
    local error_lch     = color.hex_to_oklch(mc.error)
    local bg_lch        = color.hex_to_oklch(mc.surface)

    -- ── Ember philosophy: "one spark in a calm room" ──
    -- Primary hue is the HERO — the one vivid accent that owns keywords, cursor, links.
    -- Everything else is a supporting actor: low chroma, narrow L* band, almost tinted-grey.
    -- This creates a "monochrome hero" effect that adapts to the wallpaper's identity.
    --
    -- Chroma tiers (following ember's 12-55% saturation principle):
    --   hero     → the ONE vivid color (primary hue). Keywords, cursor, accent.
    --   cast     → supporting accents. Clear but calm. Functions, types, constants.
    --   whisper  → data colors. Nearly grey with a tint. Strings, numbers, props.

    local accent_L      = color.ensure_contrast(primary_lch.L, bg_lch.L, opts.min_contrast)
    local raw_C         = primary_lch.C

    local hero_C        = math.min(raw_C, 0.10)   -- the one spark
    local cast_C        = math.min(raw_C * 0.45, 0.05) -- supporting — visible tint, not color
    local whisper_C     = math.min(raw_C * 0.30, 0.035) -- data — tinted grey

    -- ── Named accent colors ──
    -- Terminal/UI palette: use cast-level chroma (they're background actors)
    for _, name in ipairs(ACCENT_NAMES) do
        local h = color.harmonize_hue(ACCENT_HUES[name], primary_lch.h, opts.harmonize)
        pal[name] = color.oklch(accent_L, cast_C, h)
    end

    -- Dark variants
    local dark_L       = math.max(accent_L - 0.20, 0.35)
    pal.dark_blue      = color.oklch(dark_L, whisper_C,
        color.harmonize_hue(ACCENT_HUES.blue, primary_lch.h, opts.harmonize))
    pal.dark_cyan      = color.oklch(dark_L, whisper_C,
        color.harmonize_hue(ACCENT_HUES.cyan, primary_lch.h, opts.harmonize))

    -- ── Semantic roles ──
    -- The hero/cast/whisper hierarchy:
    --   HERO:    kw, accent — the wallpaper's primary hue at full chroma. The spark.
    --   CAST:    fn, type, preproc, const — distinct hues at low chroma. Supporting actors.
    --   WHISPER: str, num, prop — barely tinted. Data recedes so structure stands out.
    local ph, sh, th   = primary_lch.h, secondary_lch.h, tertiary_lch.h
    ph, sh, th         = spread_hues(ph, sh, th, 30)

    -- Hero — keywords own the primary hue
    pal.kw             = color.oklch(accent_L, hero_C, ph)
    pal.accent         = color.oklch(accent_L, hero_C, primary_lch.h)

    -- Cast — supporting identifiers
    pal.fn             = color.oklch(accent_L, cast_C, th)
    pal.builtin        = color.oklch(accent_L, cast_C * 0.85, th)
    pal.type           = color.oklch(accent_L, cast_C, sh)
    pal.const          = color.oklch(accent_L, cast_C,
        color.harmonize_hue(ACCENT_HUES.violet, primary_lch.h, opts.harmonize))
    pal.preproc        = color.oklch(accent_L, cast_C,
        color.harmonize_hue(ACCENT_HUES.blue, primary_lch.h, opts.harmonize))

    -- Whisper — data values
    pal.str            = color.oklch(accent_L, whisper_C,
        color.harmonize_hue(ACCENT_HUES.yellow, primary_lch.h, opts.harmonize))
    pal.num            = color.oklch(accent_L, whisper_C,
        color.harmonize_hue(ACCENT_HUES.orange, primary_lch.h, opts.harmonize))
    pal.prop           = color.oklch(accent_L, whisper_C,
        color.harmonize_hue(ACCENT_HUES.cyan, primary_lch.h, opts.harmonize))
    pal.method         = pal.prop

    -- Diagnostics: use STRONG canonical hues with only light harmonization.
    -- These must be instantly recognizable as red/yellow/green regardless of wallpaper.
    -- Diagnostics: ALWAYS vivid and recognizable, regardless of wallpaper.
    -- These are the exception to the "one spark" rule — safety colors must be strong.
    local diag_L       = math.max(accent_L, 0.72)
    local diag_C       = 0.16
    pal.error          = color.oklch(diag_L, diag_C, color.harmonize_hue(25, primary_lch.h, 8))
    pal.warning        = color.oklch(diag_L, diag_C, color.harmonize_hue(80, primary_lch.h, 8))
    pal.success        = color.oklch(diag_L, diag_C, color.harmonize_hue(145, primary_lch.h, 8))

    -- ── Diff backgrounds ──
    -- Tint the surface_container toward diff-semantic hues
    local diff_bg_lch  = color.hex_to_oklch(mc.surface_container)
    local diff_L       = diff_bg_lch.L + 0.02
    local diff_C       = 0.035

    pal.diff_add_bg    = color.oklch(diff_L, diff_C, color.harmonize_hue(145, primary_lch.h, opts.harmonize))
    pal.diff_change_bg = color.oklch(diff_L, diff_C, color.harmonize_hue(90, primary_lch.h, opts.harmonize))
    pal.diff_del_bg    = color.oklch(diff_L, diff_C, color.harmonize_hue(25, primary_lch.h, opts.harmonize))
    pal.diff_text_bg   = color.oklch(diff_L + 0.04, diff_C * 1.5, color.harmonize_hue(90, primary_lch.h, opts.harmonize))

    -- ── Brightness / Contrast adjustment ──
    -- brightness: shift all bg/surface colors in OKLCH lightness
    -- contrast: shift all fg/accent colors in the opposite direction
    local br           = opts.brightness or 0
    local ct           = opts.contrast or 0

    if br ~= 0 or ct ~= 0 then
        -- Background ramp gets brightness shift
        local bg_keys = {
            "base0", "base1", "base2", "base3", "base4", "base5",
            "bg", "bg_alt", "hl_line",
            "diff_add_bg", "diff_change_bg", "diff_del_bg", "diff_text_bg",
        }
        for _, k in ipairs(bg_keys) do
            if pal[k] then pal[k] = color.shift_lightness(pal[k], br) end
        end

        -- Mid-tones (base6-8, muted) get half the brightness shift
        local mid_keys = { "base6", "base7", "base8", "muted" }
        for _, k in ipairs(mid_keys) do
            if pal[k] then pal[k] = color.shift_lightness(pal[k], br * 0.5) end
        end

        -- Foreground and accents get contrast shift (brighter when bg gets brighter = less contrast,
        -- so we subtract brightness but add contrast)
        local fg_keys = {
            "fg", "fg_alt",
            "red", "orange", "yellow", "green", "teal", "cyan", "blue", "violet", "magenta",
            "dark_blue", "dark_cyan",
            "kw", "fn", "builtin", "type", "const", "str", "num", "prop", "method", "preproc",
            "accent", "error", "warning", "success",
        }
        for _, k in ipairs(fg_keys) do
            if pal[k] then pal[k] = color.shift_lightness(pal[k], ct - br * 0.3) end
        end
    end

    -- ── Sidebar colors ──
    -- Computed AFTER brightness so the offset is relative to the final editor bg
    local sb          = opts.sidebar_brightness or 0.02
    pal.sidebar_bg    = color.shift_lightness(pal.bg, sb)
    pal.sidebar_fg    = pal.fg
    pal.sidebar_muted = color.shift_lightness(pal.muted or pal.base7, sb * 0.5)

    return pal
end

return M
