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
return M
