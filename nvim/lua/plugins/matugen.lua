return {
    "daedlock/matugen.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("matugen").setup({
            colors_path = "~/.config/nvim/colors/colors.json",
            watch = true,
            transparent = true,
        })
        vim.cmd.colorscheme("matugen")
    end,
}
