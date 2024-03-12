local dap = require("dap")
local utils = require("lib.dap.utils")
local M = {}
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
            command = M.bin(),
            args = { "--port", port },
        },
    })
end
M.bin = function()
    return utils.masonPackagePath("codelldb") .. "/codelldb"
end
M.findDebugTarget = function(targetPrefix, depth)
    local targets = {}
    for entry in vim.fs.dir(targetPrefix, { depth = depth }) do
        if vim.fn.executable(targetPrefix .. entry) == 1 then
            table.insert(targets, entry)
        end
    end
    if #targets == 1 then
        return targetPrefix .. targets[1]
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
                coroutine.resume(coro, targetPrefix .. choice)
            end
        end)
    end)
end

return M
