local dap = require("dap")
local dap_python = require("lib.dap.python")
dap.adapters.python = dap_python.adapter
dap.configurations.python = dap_python.configuration
require("nvim-dap-virtual-text").setup()

local function repl_open()
    vim.g.dap_repl_opened = true
    dap.repl.open()
end

local function repl_close()
    vim.g.dap_repl_opened = false
    dap.repl.close()
end

local function repl_toggle()
    if not vim.g.dap_repl_opened then
        repl_open()
    else
        repl_close()
    end
end

vim.keymap.set("n", "<leader>bb", function()
    dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<leader>vv", function()
    repl_toggle()
end)
vim.keymap.set("n", "<leader>dk", function()
    dap.continue()
    repl_open()
end)
vim.keymap.set("n", "<leader>dl", function()
    dap.run_last()
end)
vim.keymap.set("n", "<leader>dn", function()
    dap.step_over()
end)
vim.keymap.set("n", "<leader>di", function()
    dap.step_into()
end)
vim.keymap.set("n", "<leader>do", function()
    dap.step_out()
end)
vim.keymap.set("n", "<leader>dt", function()
    dap.terminate()
end)
