function ApplyColors()
    vim.cmd.colorscheme("rose-pine-main")
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#ff0000", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapBreakpointLine", { ctermbg = 0, bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapBreakpointNum", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapLogPointLine", { ctermbg = 0, bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapLogPointNum", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapStoppedLine", { ctermbg = 0, bg = "#31353f" })
    vim.api.nvim_set_hl(0, "DapStoppedNum", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

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
end

ApplyColors()
