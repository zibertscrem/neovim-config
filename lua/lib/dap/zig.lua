local utils = require("lib.dap.utils")
local codelldb = require("lib.dap.codelldb")

local M = {}
local function findProgram()
    vim.fn.delete("zig-out", "rf")
    vim.fn.system({ "zig", "build", "-Doptimize=Debug" })
    return codelldb.findDebugTarget(vim.fn.getcwd() .. "/zig-out/bin/", 2)
end
M.adapter = codelldb.adapter
M.configuration = {
    {
        type = "zig",
        request = "launch",
        name = "Debug target",
        program = findProgram,
        cwd = vim.fn.getcwd,
        args = utils.supplyArguments,
    },
}
M.neotest = require("neotest-zig")({ dap = { adapter = "zig" } })
return M
