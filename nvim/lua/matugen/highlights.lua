-- matugen.nvim — Highlight group definitions

local M = {}

--- Apply all highlight groups from a palette table.
---@param p table  palette with bg, fg, accents, semantic, ramp keys
function M.apply(p)
    vim.cmd("hi clear")
    vim.o.termguicolors = true
    vim.o.background = p.bg_is_light and "light" or "dark"

    -- helper that respects the transparent flag on the palette. If a group's
    -- bg is equal to the main `p.bg` and transparency is requested, set
    -- the group's guibg to NONE so the terminal compositor shows through.
    local function hi(name, opts)
        if opts and opts.bg and p.transparent then
            if opts.bg == p.bg then
                opts = vim.tbl_extend("force", {}, opts)
                opts.bg = "NONE"
            end
        end
        vim.api.nvim_set_hl(0, name, opts)
    end
    -- ── Editor UI ──
    hi("Normal", { fg = p.fg, bg = p.bg })
    hi("NormalFloat", { fg = p.fg, bg = p.base2 })
    hi("NormalNC", { fg = p.fg, bg = p.bg })
    hi("FloatBorder", { fg = p.base5, bg = p.base2 })
    hi("FloatTitle", { fg = p.accent, bg = p.base2, bold = true })
    hi("Cursor", { bg = p.accent })
    hi("CursorLine", { bg = p.hl_line })
    hi("CursorColumn", { bg = p.hl_line })
    hi("ColorColumn", { bg = p.base2 })
    hi("LineNr", { fg = p.base5 })
    hi("CursorLineNr", { fg = p.accent, bold = true })
    hi("SignColumn", { fg = p.base5, bg = p.bg })
    hi("FoldColumn", { fg = p.base5, bg = p.bg })
    hi("Folded", { fg = p.base6, bg = p.base2 })
    hi("VertSplit", { fg = p.base4 })
    hi("WinSeparator", { fg = p.base4 })
    hi("StatusLine", { fg = p.fg, bg = p.base1 })
    hi("StatusLineNC", { fg = p.base6, bg = p.bg_alt })
    hi("TabLine", { fg = p.base6, bg = p.base2 })
    hi("TabLineSel", { fg = p.fg, bg = p.bg, bold = true })
    hi("TabLineFill", { bg = p.base1 })
    hi("WinBar", { fg = p.fg, bg = p.bg })
    hi("WinBarNC", { fg = p.base6, bg = p.bg })

    -- ── Popup / Completion ──
    hi("Pmenu", { fg = p.fg, bg = p.base2 })
    hi("PmenuSel", { fg = p.accent, bg = p.base4, bold = true })
    hi("PmenuSbar", { bg = p.base3 })
    hi("PmenuThumb", { bg = p.base5 })

    -- ── Search / Selection ──
    hi("Visual", { bg = p.base4 })
    hi("VisualNOS", { bg = p.base4 })
    hi("Search", { fg = p.accent, bg = p.base5 })
    hi("IncSearch", { fg = p.bg, bg = p.accent, bold = true })
    hi("CurSearch", { fg = p.bg, bg = p.accent, bold = true })
    hi("Substitute", { fg = p.bg, bg = p.red })

    -- ── Messages ──
    hi("MsgArea", { fg = p.fg })
    hi("ModeMsg", { fg = p.accent, bold = true })
    hi("MoreMsg", { fg = p.accent })
    hi("Question", { fg = p.accent })
    hi("ErrorMsg", { fg = p.error })
    hi("WarningMsg", { fg = p.warning })
    hi("Title", { fg = p.accent, bold = true })
    hi("Directory", { fg = p.accent })
    hi("NonText", { fg = p.base6 })
    hi("SpecialKey", { fg = p.base6 })
    hi("Conceal", { fg = p.base5 })
    hi("MatchParen", { fg = p.accent, bg = p.base4, bold = true })
    hi("Whitespace", { fg = p.base3 })

    -- ── Diff ──
    hi("DiffAdd", { bg = p.diff_add_bg })
    hi("DiffChange", { bg = p.diff_change_bg })
    hi("DiffDelete", { fg = p.red, bg = p.diff_del_bg })
    hi("DiffText", { bg = p.diff_text_bg, bold = true })

    -- ── Diagnostics ──
    hi("DiagnosticError", { fg = p.error })
    hi("DiagnosticWarn", { fg = p.warning })
    hi("DiagnosticInfo", { fg = p.blue })
    hi("DiagnosticHint", { fg = p.accent })
    hi("DiagnosticOk", { fg = p.success })
    hi("DiagnosticUnderlineError", { sp = p.error, undercurl = true })
    hi("DiagnosticUnderlineWarn", { sp = p.warning, undercurl = true })
    hi("DiagnosticUnderlineInfo", { sp = p.blue, undercurl = true })
    hi("DiagnosticUnderlineHint", { sp = p.accent, undercurl = true })
    hi("DiagnosticVirtualTextError", { fg = p.error, bg = p.base2 })
    hi("DiagnosticVirtualTextWarn", { fg = p.warning, bg = p.base2 })
    hi("DiagnosticVirtualTextInfo", { fg = p.blue, bg = p.base2 })
    hi("DiagnosticVirtualTextHint", { fg = p.accent, bg = p.base2 })
    hi("DiagnosticSignError", { fg = p.error })
    hi("DiagnosticSignWarn", { fg = p.warning })
    hi("DiagnosticSignInfo", { fg = p.blue })
    hi("DiagnosticSignHint", { fg = p.accent })
    hi("DiagnosticFloatingError", { fg = p.error })
    hi("DiagnosticFloatingWarn", { fg = p.warning })
    hi("DiagnosticFloatingInfo", { fg = p.blue })
    hi("DiagnosticFloatingHint", { fg = p.accent })

    -- ── tiny-inline-diagnostic ──
    -- The plugin reads DiagnosticError fg + "background" hi group (CursorLine by default)
    -- and blends them. Explicit bg on CursorLine above ensures blending works.
    -- Also set the plugin's own virtual text groups with bg for direct rendering.
    hi("TinyInlineDiagnosticVirtualTextError", { fg = p.error, bg = p.hl_line })
    hi("TinyInlineDiagnosticVirtualTextWarn", { fg = p.warning, bg = p.hl_line })
    hi("TinyInlineDiagnosticVirtualTextInfo", { fg = p.blue, bg = p.hl_line })
    hi("TinyInlineDiagnosticVirtualTextHint", { fg = p.accent, bg = p.hl_line })
    hi("TinyInlineDiagnosticVirtualTextArrow", { fg = p.base6 })

    -- ── Standard syntax ──
    hi("Comment", { fg = p.muted or p.base7, italic = true })
    hi("Constant", { fg = p.const, bold = true })
    hi("String", { fg = p.str })
    hi("Character", { fg = p.str })
    hi("Number", { fg = p.num, bold = true })
    hi("Float", { fg = p.num, bold = true })
    hi("Boolean", { fg = p.const, bold = true })
    hi("Identifier", { fg = p.fg })
    hi("Function", { fg = p.fn, bold = true })
    hi("Statement", { fg = p.kw, bold = true })
    hi("Conditional", { fg = p.kw, bold = true })
    hi("Repeat", { fg = p.kw, bold = true })
    hi("Label", { fg = p.kw })
    hi("Operator", { fg = p.base7 })
    hi("Keyword", { fg = p.kw, bold = true })
    hi("Exception", { fg = p.kw, bold = true })
    hi("PreProc", { fg = p.preproc, bold = true })
    hi("Include", { fg = p.preproc, bold = true })
    hi("Define", { fg = p.preproc, bold = true })
    hi("Macro", { fg = p.preproc, bold = true })
    hi("Type", { fg = p.type, bold = true, italic = true })
    hi("StorageClass", { fg = p.kw, bold = true })
    hi("Structure", { fg = p.type, bold = true })
    hi("Typedef", { fg = p.type, bold = true })
    hi("Special", { fg = p.builtin })
    hi("SpecialChar", { fg = p.orange })
    hi("Tag", { fg = p.accent })
    hi("Delimiter", { fg = p.base7 })
    hi("SpecialComment", { fg = p.muted or p.base7, italic = true })
    hi("Debug", { fg = p.orange })
    hi("Underlined", { fg = p.accent, underline = true })
    hi("Error", { fg = p.error })
    hi("Todo", { fg = p.accent, bold = true })

    -- ── Treesitter ──
    hi("@variable", { fg = p.fg })
    hi("@variable.builtin", { fg = p.builtin, italic = true })
    hi("@variable.parameter", { fg = p.fg_alt })
    hi("@variable.member", { fg = p.prop })
    hi("@constant", { fg = p.const, bold = true })
    hi("@constant.builtin", { fg = p.const, bold = true })
    hi("@constant.macro", { fg = p.const })
    hi("@module", { fg = p.fg_alt })
    hi("@string", { fg = p.str })
    hi("@string.documentation", { fg = p.base7, italic = true })
    hi("@string.regexp", { fg = p.orange })
    hi("@string.escape", { fg = p.orange, bold = true })
    hi("@character", { fg = p.str })
    hi("@number", { fg = p.num, bold = true })
    hi("@number.float", { fg = p.num, bold = true })
    hi("@boolean", { fg = p.const, bold = true })
    hi("@type", { fg = p.type, bold = true, italic = true })
    hi("@type.builtin", { fg = p.type, italic = true })
    hi("@type.definition", { fg = p.type, bold = true })
    hi("@attribute", { fg = p.preproc })
    hi("@property", { fg = p.prop })
    hi("@function", { fg = p.fn, bold = true })
    hi("@function.builtin", { fg = p.builtin, bold = true })
    hi("@function.call", { fg = p.fn })
    hi("@function.macro", { fg = p.preproc })
    hi("@function.method", { fg = p.method or p.fn })
    hi("@function.method.call", { fg = p.method or p.fn })
    hi("@constructor", { fg = p.type, bold = true })
    hi("@operator", { fg = p.base7 })
    hi("@keyword", { fg = p.kw, bold = true })
    hi("@keyword.coroutine", { fg = p.kw, bold = true })
    hi("@keyword.function", { fg = p.kw, bold = true })
    hi("@keyword.operator", { fg = p.kw })
    hi("@keyword.import", { fg = p.preproc, bold = true })
    hi("@keyword.type", { fg = p.kw, bold = true })
    hi("@keyword.modifier", { fg = p.kw, italic = true })
    hi("@keyword.repeat", { fg = p.kw, bold = true })
    hi("@keyword.return", { fg = p.kw, bold = true })
    hi("@keyword.debug", { fg = p.orange })
    hi("@keyword.exception", { fg = p.kw, bold = true })
    hi("@keyword.conditional", { fg = p.kw, bold = true })
    hi("@keyword.directive", { fg = p.preproc, bold = true })
    hi("@punctuation.bracket", { fg = p.base7 })
    hi("@punctuation.delimiter", { fg = p.base7 })
    hi("@punctuation.special", { fg = p.base7 })
    hi("@comment", { fg = p.muted or p.base7, italic = true })
    hi("@comment.documentation", { fg = p.muted or p.base7, italic = true })
    hi("@comment.error", { fg = p.error, bold = true })
    hi("@comment.warning", { fg = p.warning, bold = true })
    hi("@comment.todo", { fg = p.accent, bold = true })
    hi("@comment.note", { fg = p.blue, bold = true })
    hi("@markup.heading", { fg = p.accent, bold = true })
    hi("@markup.heading.1", { fg = p.accent, bold = true })
    hi("@markup.heading.2", { fg = p.fn, bold = true })
    hi("@markup.heading.3", { fg = p.blue })
    hi("@markup.heading.4", { fg = p.cyan })
    hi("@markup.strong", { bold = true })
    hi("@markup.italic", { italic = true })
    hi("@markup.strikethrough", { strikethrough = true })
    hi("@markup.underline", { underline = true })
    hi("@markup.link", { fg = p.accent, underline = true })
    hi("@markup.link.url", { fg = p.blue, underline = true })
    hi("@markup.raw", { fg = p.orange })
    hi("@markup.list", { fg = p.accent })
    hi("@tag", { fg = p.accent })
    hi("@tag.attribute", { fg = p.prop })
    hi("@tag.delimiter", { fg = p.base7 })

    -- ── LSP semantic tokens ──
    hi("@lsp.type.class", { link = "@type" })
    hi("@lsp.type.decorator", { link = "@attribute" })
    hi("@lsp.type.enum", { link = "@type" })
    hi("@lsp.type.enumMember", { link = "@constant" })
    hi("@lsp.type.function", { link = "@function" })
    hi("@lsp.type.interface", { link = "@type" })
    hi("@lsp.type.macro", { link = "@function.macro" })
    hi("@lsp.type.method", { link = "@function.method" })
    hi("@lsp.type.namespace", { link = "@module" })
    hi("@lsp.type.parameter", { link = "@variable.parameter" })
    hi("@lsp.type.property", { link = "@property" })
    hi("@lsp.type.struct", { link = "@type" })
    hi("@lsp.type.type", { link = "@type" })
    hi("@lsp.type.typeParameter", { link = "@type" })
    hi("@lsp.type.variable", { link = "@variable" })

    -- ── Git signs ──
    hi("GitSignsAdd", { fg = p.success })
    hi("GitSignsChange", { fg = p.warning })
    hi("GitSignsDelete", { fg = p.error })
    hi("Added", { fg = p.success })
    hi("Changed", { fg = p.warning })
    hi("Removed", { fg = p.error })

    -- ── Snacks picker ──
    hi("SnacksPicker", { fg = p.fg, bg = p.bg })
    hi("SnacksPickerBorder", { fg = p.base4, bg = p.bg })
    hi("SnacksPickerTitle", { fg = p.accent, bg = p.bg, bold = true })
    hi("SnacksPickerInput", { fg = p.fg, bg = p.base2 })
    hi("SnacksPickerInputBorder", { fg = p.accent, bg = p.base2 })
    hi("SnacksPickerInputSearch", { fg = p.accent })
    hi("SnacksPickerPrompt", { fg = p.accent })
    hi("SnacksPickerList", { fg = p.fg, bg = p.bg })
    hi("SnacksPickerListBorder", { fg = p.base4, bg = p.bg })
    hi("SnacksPickerListCursorLine", { bg = p.base3 })
    hi("SnacksPickerPreview", { fg = p.fg, bg = p.bg })
    hi("SnacksPickerPreviewBorder", { fg = p.base4, bg = p.bg })
    hi("SnacksPickerPreviewTitle", { fg = p.bg, bg = p.accent, bold = true })
    hi("SnacksPickerDir", { fg = p.muted or p.base8 })
    hi("SnacksPickerFile", { fg = p.fg })
    hi("SnacksPickerMatch", { fg = p.accent, bold = true })
    hi("SnacksPickerSelected", { fg = p.accent, bg = p.base3, bold = true })
    hi("SnacksPickerIcon", { fg = p.muted or p.base8 })
    hi("SnacksPickerIconFile", { fg = p.fg_alt })
    hi("SnacksPickerCount", { fg = p.base7 })
    hi("SnacksPickerSpecial", { fg = p.accent })
    hi("SnacksPickerTotals", { fg = p.base7 })
    hi("SnacksPickerLabel", { fg = p.fg })
    hi("SnacksPickerLabelFile", { fg = p.fg })

    -- Force picker Normal so no item falls back to a dim group
    hi("SnacksPickerNormal", { fg = p.fg, bg = p.bg })

    -- Picker metadata columns (keymaps, commands, etc.)
    hi("SnacksPickerIdx", { fg = p.muted or p.base7 })
    hi("SnacksPickerCol", { fg = p.muted or p.base7 })
    hi("SnacksPickerRow", { fg = p.muted or p.base7 })
    hi("SnacksPickerComment", { fg = p.muted or p.base7 })
    hi("SnacksPickerInfo", { fg = p.muted or p.base7 })
    hi("SnacksPickerCmd", { fg = p.fg_alt })
    hi("SnacksPickerBuf", { fg = p.muted or p.base7 })
    hi("SnacksPickerFlag", { fg = p.accent })
    hi("SnacksPickerKey", { fg = p.accent, bold = true })
    hi("SnacksPickerMode", { fg = p.fg_alt })
    hi("SnacksPickerSource", { fg = p.muted or p.base7 })

    -- Telescope fallbacks (some plugins still reference these)
    hi("TelescopeBorder", { fg = p.base4, bg = p.bg })
    hi("TelescopeNormal", { fg = p.fg, bg = p.bg })
    hi("TelescopeSelection", { fg = p.accent, bg = p.base3, bold = true })
    hi("TelescopeMatching", { fg = p.accent, bold = true })
    hi("TelescopePromptPrefix", { fg = p.accent })

    -- ── Snacks explorer / sidebar ──
    local sb_bg = p.sidebar_bg or p.base1
    local sb_fg = p.sidebar_fg or p.fg
    local sb_muted = p.sidebar_muted or p.muted or p.base7

    hi("SnacksExplorerNormal", { fg = sb_fg, bg = sb_bg })
    hi("SnacksExplorerNormalFloat", { fg = sb_fg, bg = sb_bg })
    hi("SnacksExplorerDir", { fg = sb_muted })
    hi("SnacksExplorerFile", { fg = sb_fg })
    hi("SnacksExplorerTree", { fg = p.base4 })
    hi("SnacksExplorerCursorLine", { bg = p.base3 })

    -- ── Snacks notifier ──
    hi("SnacksNotifierNormal", { fg = p.fg, bg = p.base2 })
    hi("SnacksNotifierBorder", { fg = p.base4, bg = p.base2 })

    -- ── Snacks terminal ──
    hi("SnacksTerminalNormal", { fg = p.fg, bg = p.bg })
    hi("SnacksTerminalBorder", { fg = p.base4, bg = p.bg })

    -- ── Indent guides ──
    hi("IblIndent", { fg = p.base3 })
    hi("IblScope", { fg = p.base5 })
    hi("IndentLine", { fg = p.base3 })
    hi("SnacksIndent", { fg = p.base3 })
    hi("SnacksIndentScope", { fg = p.base5 })

    -- ── Which-key ──
    hi("WhichKey", { fg = p.accent })
    hi("WhichKeyGroup", { fg = p.kw })
    hi("WhichKeyDesc", { fg = p.fg })
    hi("WhichKeySeparator", { fg = p.base6 })
    hi("WhichKeyNormal", { fg = p.fg, bg = p.bg })
    hi("WhichKeyBorder", { fg = p.base4, bg = p.bg })
    hi("WhichKeyValue", { fg = p.muted or p.base7 })

    -- ── Markdown ──
    hi("markdownH1", { fg = p.accent, bold = true })
    hi("markdownH2", { fg = p.fn, bold = true })
    hi("markdownH3", { fg = p.blue })
    hi("markdownCode", { fg = p.orange })
    hi("markdownCodeBlock", { fg = p.orange })
    hi("markdownLinkText", { fg = p.accent, underline = true })

    -- ── Notify ──
    hi("NotifyERRORBorder", { fg = p.error })
    hi("NotifyERRORIcon", { fg = p.error })
    hi("NotifyERRORTitle", { fg = p.error })
    hi("NotifyWARNBorder", { fg = p.warning })
    hi("NotifyWARNIcon", { fg = p.warning })
    hi("NotifyWARNTitle", { fg = p.warning })
    hi("NotifyINFOBorder", { fg = p.accent })
    hi("NotifyINFOIcon", { fg = p.accent })
    hi("NotifyINFOTitle", { fg = p.accent })

    -- ── Lazy ──
    hi("LazyH1", { fg = p.bg, bg = p.accent, bold = true })
    hi("LazyButton", { fg = p.fg, bg = p.base3 })
    hi("LazyButtonActive", { fg = p.bg, bg = p.accent, bold = true })

    -- ── Snacks dashboard ──
    hi("SnacksDashboardHeader", { fg = p.accent })
    hi("SnacksDashboardFooter", { fg = p.base5 })
    hi("SnacksDashboardIcon", { fg = p.accent })
    hi("SnacksDashboardKey", { fg = p.accent })
    hi("SnacksDashboardDesc", { fg = p.fg })

    -- ── Blink/cmp ──
    hi("BlinkCmpMenu", { fg = p.fg, bg = p.base2 })
    hi("BlinkCmpMenuSelection", { fg = p.accent, bg = p.base4, bold = true })
    hi("BlinkCmpMenuBorder", { fg = p.base4, bg = p.base2 })
    hi("BlinkCmpLabel", { fg = p.fg })
    hi("BlinkCmpLabelMatch", { fg = p.accent, bold = true })
    hi("BlinkCmpKind", { fg = p.base6 })
    hi("BlinkCmpDoc", { fg = p.fg, bg = p.base2 })
    hi("BlinkCmpDocBorder", { fg = p.base4, bg = p.base2 })

    -- ── Oil ──
    hi("OilDir", { fg = p.accent, bold = true })
    hi("OilFile", { fg = p.fg })

    -- ── Trouble ──
    hi("TroubleNormal", { fg = p.fg, bg = p.bg })
    hi("TroubleCount", { fg = p.accent, bold = true })

    -- ── Neo-tree ──
    hi("NeoTreeNormal", { fg = sb_fg, bg = sb_bg })
    hi("NeoTreeNormalNC", { fg = sb_fg, bg = sb_bg })
    hi("NeoTreeEndOfBuffer", { fg = sb_bg, bg = sb_bg })
    hi("NeoTreeCursorLine", { bg = p.base3 })
    hi("NeoTreeDirectoryName", { fg = p.accent })
    hi("NeoTreeDirectoryIcon", { fg = p.accent })
    hi("NeoTreeFileName", { fg = sb_fg })
    hi("NeoTreeFileIcon", { fg = sb_muted })
    hi("NeoTreeGitAdded", { fg = p.success })
    hi("NeoTreeGitConflict", { fg = p.error })
    hi("NeoTreeGitDeleted", { fg = p.error })
    hi("NeoTreeGitModified", { fg = p.warning })
    hi("NeoTreeGitUntracked", { fg = sb_muted })
    hi("NeoTreeIndentMarker", { fg = p.base4 })
    hi("NeoTreeRootName", { fg = p.accent, bold = true })
    hi("NeoTreeSymbolicLinkTarget", { fg = p.cyan })
    hi("NeoTreeTitleBar", { fg = sb_bg, bg = p.accent, bold = true })
    hi("NeoTreeFloatBorder", { fg = p.base4, bg = sb_bg })
    hi("NeoTreeFloatNormal", { fg = sb_fg, bg = sb_bg })
    hi("NeoTreeWinSeparator", { fg = p.base3, bg = sb_bg })
    hi("NeoTreeTabActive", { fg = p.accent, bg = sb_bg, bold = true })
    hi("NeoTreeTabInactive", { fg = sb_muted, bg = p.base0 })
    hi("NeoTreeTabSeparatorActive", { fg = sb_bg, bg = sb_bg })
    hi("NeoTreeTabSeparatorInactive", { fg = p.base0, bg = p.base0 })
    hi("NeoTreeDimText", { fg = sb_muted })
    hi("NeoTreeMessage", { fg = sb_muted })

    -- ── Mini.files ──
    hi("MiniFilesBorder", { fg = p.base4, bg = p.base2 })
    hi("MiniFilesNormal", { fg = p.fg, bg = p.base2 })
    hi("MiniFilesTitle", { fg = p.accent, bg = p.base2, bold = true })
    hi("MiniFilesCursorLine", { bg = p.base3 })
    hi("MiniFilesDirectory", { fg = p.accent })
    hi("MiniFilesFile", { fg = p.fg })

    -- ── Barbecue (breadcrumbs) ──
    hi("barbecue_normal", { fg = p.muted or p.base7, bg = p.bg })
    hi("barbecue_context", { fg = p.muted or p.base8 })
    hi("barbecue_separator", { fg = p.base6 })
    hi("barbecue_modified", { fg = p.warning })

    -- ── Lualine ──
    -- Define highlight groups that lualine's "auto" theme picks up,
    -- plus expose a proper lualine theme via get_lualine_theme()
    hi("lualine_a_normal", { fg = p.bg, bg = p.accent, bold = true })
    hi("lualine_b_normal", { fg = p.accent, bg = p.base3 })
    hi("lualine_c_normal", { fg = p.fg_alt, bg = p.base1 })

    hi("lualine_a_insert", { fg = p.bg, bg = p.green, bold = true })
    hi("lualine_b_insert", { fg = p.green, bg = p.base3 })
    hi("lualine_c_insert", { fg = p.fg_alt, bg = p.base1 })

    hi("lualine_a_visual", { fg = p.bg, bg = p.magenta, bold = true })
    hi("lualine_b_visual", { fg = p.magenta, bg = p.base3 })
    hi("lualine_c_visual", { fg = p.fg_alt, bg = p.base1 })

    hi("lualine_a_replace", { fg = p.bg, bg = p.red, bold = true })
    hi("lualine_b_replace", { fg = p.red, bg = p.base3 })
    hi("lualine_c_replace", { fg = p.fg_alt, bg = p.base1 })

    hi("lualine_a_command", { fg = p.bg, bg = p.orange, bold = true })
    hi("lualine_b_command", { fg = p.orange, bg = p.base3 })
    hi("lualine_c_command", { fg = p.fg_alt, bg = p.base1 })

    hi("lualine_a_inactive", { fg = p.base6, bg = p.base2 })
    hi("lualine_b_inactive", { fg = p.base6, bg = p.base1 })
    hi("lualine_c_inactive", { fg = p.base5, bg = p.base0 })

    -- ── Terminal ANSI ──
    vim.g.terminal_color_0  = p.base2
    vim.g.terminal_color_1  = p.red
    vim.g.terminal_color_2  = p.green
    vim.g.terminal_color_3  = p.yellow
    vim.g.terminal_color_4  = p.blue
    vim.g.terminal_color_5  = p.magenta
    vim.g.terminal_color_6  = p.cyan
    vim.g.terminal_color_7  = p.fg
    vim.g.terminal_color_8  = p.base4
    vim.g.terminal_color_9  = p.red
    vim.g.terminal_color_10 = p.green
    vim.g.terminal_color_11 = p.yellow
    vim.g.terminal_color_12 = p.blue
    vim.g.terminal_color_13 = p.magenta
    vim.g.terminal_color_14 = p.cyan
    vim.g.terminal_color_15 = p.fg
end

return M
