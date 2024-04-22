local utils = require("lib.dap.utils")
local M = {}
local function buildFlags()
    return ""
end
local function dlvBin()
    if vim.fn.executable("dlv") == 1 then
        return "dlv"
    end
    return utils.masonPackagePath("delve") .. "/dlv"
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
        port = assert(port, "`connect.port` is required for a delve `attach` configuration"),
        host = host,
        executable = {
            command = dlvBin(),
            args = { "dap", "-l", host .. ":" .. port },
        },
        options = {
            source_filetype = "go",
            initialize_timeout_sec = 20,
        },
    })
end
M.configuration = {
    {
        type = "go",
        request = "launch",
        name = "Debug file",
        program = "${file}",
        args = utils.supplyArguments,
        buildFlags = buildFlags,
    },
    {
        type = "go",
        request = "launch",
        name = "Debug tests package",
        program = "./${relativeFileDirname}",
        mode = "test",
        buildFlags = buildFlags,
    },
}
M.neotest = require("neotest-go")({
    recursive_run = true,
})
return M
