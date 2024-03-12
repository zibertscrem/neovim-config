local dap = require("dap")
local utils = require("lib.dap.utils")
local codelldb = require("lib.dap.codelldb")

local M = {}
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
M.adapter = codelldb.adapter
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
