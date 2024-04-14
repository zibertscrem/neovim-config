function ApplyColors()
    require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
    })
    vim.cmd.colorscheme("catppuccin")

    vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#ff0000", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapBreakpointLine", { ctermbg = 0, bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapBreakpointNum", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapLogPointLine", { ctermbg = 0, bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapLogPointNum", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapStoppedLine", { ctermbg = 0, bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapStoppedNum", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

    vim.api.nvim_set_hl(0, "RainbowRed", { ctermbg = 0, fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { ctermbg = 0, fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { ctermbg = 0, fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { ctermbg = 0, fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { ctermbg = 0, fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { ctermbg = 0, fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { ctermbg = 0, fg = "#56B6C2" })

    local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
    }

    vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DapBreakpoint",
        linehl = "DapBreakpointLine",
        numhl = "DapBreakpointNum",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "DapBreakpoint",
        linehl = "DapBreakpointLine",
        numhl = "DapBreakpointNum",
    })
    vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DapBreakpoint",
        linehl = "DapBreakpointLine",
        numhl = "DapBreakpointNum",
    })
    vim.fn.sign_define("DapLogPoint", {
        text = "",
        texthl = "DapLogPoint",
        linehl = "DapLogPointLine",
        numhl = "DapLogPointNum",
    })
    vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "DapStoppedNum",
    })
    require("rainbow-delimiters.setup").setup({
        highlight = highlight,
        blacklist = { "zig" },
    })
    require("ibl").setup({
        indent = { highlight = highlight },
        exclude = { filetypes = { "zig" } },
    })
    require("lualine").setup({ options = { theme = "material" } })
end

ApplyColors()
