local dap = require("dap")
local utils = require("lib.dap.utils")
local codelldb = require("lib.dap.codelldb")

local M = {}
local function findProgram()
    vim.fn.system({ "zig", "build", "-Doptimize=Debug" })
    local cwd = vim.fn.getcwd()
    local targets = {}
    for entry in vim.fs.dir(cwd .. "/zig-out/bin/") do
        if vim.fn.executable(cwd .. "/zig-out/bin/" .. entry) == 1 then
            table.insert(targets, entry)
        end
    end
    if #targets == 1 then
        return cwd .. "/zig-out/bin/" .. targets[1]
    end
    if #targets == 0 then
        vim.print("Cannot find debug target")
        return dap.ABORT
    end
    return coroutine.create(function(coro)
        vim.ui.select(targets, {
            prompt = "Select target to debug: ",
        }, function(choice)
            if choice == nil then
                coroutine.resume(coro, dap.ABORT)
            else
                coroutine.resume(coro, cwd .. "/zig-out/bin/" .. choice)
            end
        end)
    end)
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
return M
