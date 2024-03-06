local dap = require("dap")
local utils = require("lib.dap.utils")

local M = {}
local function codelldbBin()
    return utils.masonPackagePath("codelldb") .. "/codelldb"
end
local function extractTarget()
    local cwd = vim.fn.getcwd()
    local cargoFile = cwd .. "/Cargo.toml"
    if vim.fn.filereadable(cargoFile) ~= 1 then
        vim.print("Cannot find Cargo.toml. Search path: " .. cargoFile)
        return nil
    end
    local cargoContent = vim.fn.system({ "cat", cargoFile })
    return string.match(cargoContent, '%[package%].-name%s*=%s*"([^"]+)"')
end
local function findProgram()
    local target = extractTarget()
    if not target or target == "" then
        return dap.ABORT
    end
    vim.fn.system({ "cargo", "clean" })
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
        name = "Debug target",
        program = findProgram,
        cwd = vim.fn.getcwd,
        args = utils.supplyArguments,
    },
}
return M
