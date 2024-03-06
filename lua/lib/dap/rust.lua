local dap = require("dap")
local utils = require("lib.dap.utils")

local M = {}
local function codelldbBin()
    return utils.masonPackagePath("codelldb") .. "/codelldb"
end
local function findProgram()
    local defaultTarget = ""
    if vim.g.dap_rust_target then
        defaultTarget = vim.g.dap_rust_target
    end
    local target = vim.fn.input({
        prompt = "Target: ",
        default = defaultTarget,
    })
    target = vim.trim(target)
    if target == "" then
        return dap.ABORT
    end
    vim.fn.system({ "cargo", "build" })
    local debugTarget = vim.fn.getcwd() .. "/target/debug/" .. target
    if vim.fn.executable(debugTarget) ~= 1 then
        vim.print("Cannot find debug target")
        return dap.ABORT
    end
    vim.g.dap_rust_target = target
    return debugTarget
end
M.adapter = function(cb, config)
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    if not port then
        port = "${port}"
    end
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or "127.0.0.1"
    cb({
        type = "server",
        port = assert(port, "port is required for codelldb"),
        host = host,
        executable = {
            command = codelldbBin(),
            args = { "--port", port },
        },
    })
end
M.configuration = {
    {
        type = "rust",
        request = "launch",
        name = "Debug program",
        program = findProgram,
        args = utils.supplyArguments,
    },
}
return M
