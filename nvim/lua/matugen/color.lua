-- matugen.nvim — OKLCH color science
-- sRGB ↔ OKLAB ↔ OKLCH conversion + perceptual color manipulation

local M = {}

local pi = math.pi

local function srgb_to_linear(x)
    if x <= 0.04045 then return x / 12.92 end
    return ((x + 0.055) / 1.055) ^ 2.4
end

local function linear_to_srgb(x)
    if x <= 0.0031308 then return x * 12.92 end
    return 1.055 * x ^ (1 / 2.4) - 0.055
end

local function cbrt(x)
    if x >= 0 then return x ^ (1 / 3) end
    return -((-x) ^ (1 / 3))
end

local function clamp(x, lo, hi)
    if x < lo then return lo end
    if x > hi then return hi end
    return x
end

--- Parse "#RRGGBB" (or "RRGGBB") to {r, g, b} in [0,1].
--- Errors with a clear message on malformed input — better than a cryptic
--- "arithmetic on nil" deep in the OKLCH pipeline.
function M.hex_to_rgb(hex)
    if type(hex) ~= "string" then
        error("matugen.nvim: expected hex color string, got " .. type(hex), 2)
    end
    local body = hex:gsub("^#", "")
    if #body ~= 6 then
        error("matugen.nvim: invalid hex color " .. string.format("%q", hex)
            .. " (expected 6 hex chars)", 2)
    end
    local r = tonumber(body:sub(1, 2), 16)
    local g = tonumber(body:sub(3, 4), 16)
    local b = tonumber(body:sub(5, 6), 16)
    if not (r and g and b) then
        error("matugen.nvim: invalid hex color " .. string.format("%q", hex), 2)
    end
    return { r = r / 255, g = g / 255, b = b / 255 }
end

--- {r, g, b} in [0,1] to "#rrggbb"
function M.rgb_to_hex(rgb)
    return string.format("#%02x%02x%02x",
        math.floor(clamp(rgb.r, 0, 1) * 255 + 0.5),
        math.floor(clamp(rgb.g, 0, 1) * 255 + 0.5),
        math.floor(clamp(rgb.b, 0, 1) * 255 + 0.5))
end

--- sRGB hex → OKLAB {L, a, b}
function M.hex_to_oklab(hex)
    local rgb = M.hex_to_rgb(hex)
    local lr = srgb_to_linear(rgb.r)
    local lg = srgb_to_linear(rgb.g)
    local lb = srgb_to_linear(rgb.b)

    local l = 0.4122214708 * lr + 0.5363325363 * lg + 0.0514459929 * lb
    local m = 0.2119034982 * lr + 0.6806995451 * lg + 0.1073969566 * lb
    local s = 0.0883024619 * lr + 0.2220049168 * lg + 0.6896926214 * lb

    local l_ = cbrt(l)
    local m_ = cbrt(m)
    local s_ = cbrt(s)

    return {
        L = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
        a = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
        b = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
    }
end

--- OKLAB {L, a, b} → sRGB {r, g, b} (may be out of gamut)
function M.oklab_to_rgb(lab)
    local l_ = lab.L + 0.3963377774 * lab.a + 0.2158037573 * lab.b
    local m_ = lab.L - 0.1055613458 * lab.a - 0.0638541728 * lab.b
    local s_ = lab.L - 0.0894841775 * lab.a - 1.2914855480 * lab.b

    local l = l_ * l_ * l_
    local m = m_ * m_ * m_
    local s = s_ * s_ * s_

    return {
        r = linear_to_srgb(4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s),
        g = linear_to_srgb(-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s),
        b = linear_to_srgb(-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s),
    }
end

--- OKLAB → OKLCH {L, C, h} (h in degrees)
function M.oklab_to_oklch(lab)
    local C = math.sqrt(lab.a * lab.a + lab.b * lab.b)
    local h = math.atan2(lab.b, lab.a) * 180 / pi
    if h < 0 then h = h + 360 end
    return { L = lab.L, C = C, h = h }
end

--- OKLCH {L, C, h} → OKLAB {L, a, b}
function M.oklch_to_oklab(lch)
    local h_rad = lch.h * pi / 180
    return {
        L = lch.L,
        a = lch.C * math.cos(h_rad),
        b = lch.C * math.sin(h_rad),
    }
end

--- Hex → OKLCH
function M.hex_to_oklch(hex)
    return M.oklab_to_oklch(M.hex_to_oklab(hex))
end

--- OKLCH → hex (unclamped — call gamut_map first for safety)
function M.oklch_to_hex(lch)
    local lab = M.oklch_to_oklab(lch)
    local rgb = M.oklab_to_rgb(lab)
    rgb.r = clamp(rgb.r, 0, 1)
    rgb.g = clamp(rgb.g, 0, 1)
    rgb.b = clamp(rgb.b, 0, 1)
    return M.rgb_to_hex(rgb)
end

--- Is (L, C, h) inside the sRGB cube? (small epsilon for rounding)
function M.in_gamut(L, C, h)
    local lab = M.oklch_to_oklab({ L = L, C = C, h = h })
    local rgb = M.oklab_to_rgb(lab)
    local e = 0.002
    return rgb.r >= -e and rgb.r <= 1 + e
        and rgb.g >= -e and rgb.g <= 1 + e
        and rgb.b >= -e and rgb.b <= 1 + e
end

--- Reduce chroma until (L, C, h) fits sRGB. Returns L, C, h.
function M.gamut_map(L, C, h)
    if M.in_gamut(L, C, h) then return L, C, h end
    local lo, hi = 0, C
    for _ = 1, 24 do
        local mid = (lo + hi) * 0.5
        if M.in_gamut(L, mid, h) then lo = mid else hi = mid end
    end
    return L, lo, h
end

--- Create a gamut-safe hex color from OKLCH components.
function M.oklch(L, C, h)
    local gL, gC, gH = M.gamut_map(L, C, h % 360)
    return M.oklch_to_hex({ L = gL, C = gC, h = gH })
end

--- Harmonize source_h toward target_h by up to max_rotation degrees.
--- Follows Material You's blend algorithm: half the angular distance, capped.
function M.harmonize_hue(source_h, target_h, max_rotation)
    max_rotation = max_rotation or 15
    local diff = ((target_h - source_h + 180) % 360) - 180
    local rotation = diff * 0.5
    rotation = clamp(rotation, -max_rotation, max_rotation)
    return (source_h + rotation) % 360
end

--- Shortest angular distance between two hues (0–180).
function M.hue_distance(h1, h2)
    return math.abs(((h1 - h2 + 180) % 360) - 180)
end

--- Push fg lightness away from bg lightness until delta >= min_delta.
function M.ensure_contrast(fg_L, bg_L, min_delta)
    min_delta = min_delta or 0.45
    if math.abs(fg_L - bg_L) >= min_delta then return fg_L end
    if bg_L < 0.5 then
        return math.min(1.0, bg_L + min_delta)
    else
        return math.max(0.0, bg_L - min_delta)
    end
end

--- Shift the OKLCH lightness of a hex color by delta, preserving hue and chroma.
--- Positive delta = lighter, negative = darker. Gamut-safe.
function M.shift_lightness(hex, delta)
    local lch = M.hex_to_oklch(hex)
    return M.oklch(clamp(lch.L + delta, 0, 1), lch.C, lch.h)
end

--- Scale the OKLCH chroma of a hex color by factor, preserving hue and lightness.
function M.scale_chroma(hex, factor)
    local lch = M.hex_to_oklch(hex)
    return M.oklch(lch.L, lch.C * factor, lch.h)
end

--- Linearly interpolate between two OKLCH colors.
function M.mix(hex1, hex2, t)
    local a = M.hex_to_oklch(hex1)
    local b = M.hex_to_oklch(hex2)
    -- Handle hue interpolation across the 0/360 boundary
    local h_diff = ((b.h - a.h + 180) % 360) - 180
    local h = (a.h + h_diff * t) % 360
    return M.oklch(
        a.L + (b.L - a.L) * t,
        a.C + (b.C - a.C) * t,
        h
    )
end

return M
