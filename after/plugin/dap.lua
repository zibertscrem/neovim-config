local dap = require("dap")
dap.adapters.python = function(cb, config)
    if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
                source_filetype = "python",
            },
        })
    else
        cb({
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
            args = { "-m", "debugpy.adapter" },
            options = {
                source_filetype = "python",
            },
        })
    end
end
dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}", -- This configuration will launch the current file if used.
        pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                return cwd .. "/.venv/bin/python"
            else
                return "python"
            end
        end,
    },
}
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
    repl_open()
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
