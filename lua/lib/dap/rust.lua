local utils = require("lib.dap.utils")
local codelldb = require("lib.dap.codelldb")

local M = {}
local function findProgram()
    vim.fn.system({ "cargo", "clean" })
    vim.fn.system({ "cargo", "build" })
    return codelldb.findDebugTarget(vim.fn.getcwd() .. "/target/", 2)
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
M.neotest = require("rustaceanvim.neotest")
return M
