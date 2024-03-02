local dap = require("dap")
local dap_virtual_text = require("nvim-dap-virtual-text")
local dapui = require("dapui")
local dap_python = require("lib.dap.python")

dap_virtual_text.setup()
dapui.setup()
-- Python DAP
dap.adapters.python = dap_python.adapter
dap.configurations.python = dap_python.configuration

-- DAP UI auto open/close settings
dap.listeners.before.attach.dapui_config = function(session, body)
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function(session, body)
    dapui.open()
end
dap.listeners.before.terminate.dapui_config = function(session, body)
    dapui.close()
end

vim.keymap.set("n", "<leader>bb", function()
    dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<leader>vv", function()
    dapui.toggle()
end)
vim.keymap.set("n", "<leader>df", function()
    dapui.float_element()
end)
vim.keymap.set({ "n", "v" }, "<leader>de", function()
    dapui.eval()
end)
vim.keymap.set("n", "<leader>dk", function()
    dap.continue()
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
