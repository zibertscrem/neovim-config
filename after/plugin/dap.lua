local dap = require("dap")
local dap_virtual_text = require("nvim-dap-virtual-text")
local dapui = require("dapui")
local dap_python = require("lib.dap.python")
local dap_go = require("lib.dap.go")

dap_virtual_text.setup()
dapui.setup()

-- Python DAP
dap.adapters.python = dap_python.adapter
dap.configurations.python = dap_python.configuration
-- Go DAP
dap.adapters.go = dap_go.adapter
dap.configurations.go = dap_go.configuration

-- DAP UI auto open/close settings
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.terminate.dapui_config = function()
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
    vim.ui.select({
        "symbol",
        "expression",
    }, {
        prompt = "Select how to evaluate: ",
        format_item = function(item)
            return "Evaluate " .. item
        end,
    }, function(choice)
        if choice == nil then
            vim.fn.print("Skip evaluation")
            return
        end
        if choice == "symbol" then
            dapui.eval()
        else
            local defaultExpression = ""
            if vim.g.dap_expression then
                defaultExpression = vim.g.dap_expression
            end
            local expr = vim.fn.input({
                prompt = "Expression: ",
                default = defaultExpression,
            })
            vim.g.dap_expression = expr
            dapui.eval(expr)
        end
    end)
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
