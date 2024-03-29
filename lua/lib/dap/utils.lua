local mason_path = require("mason-core.path")
local M = {}

function M.masonPackagePath(pkg)
    return mason_path.package_prefix(pkg)
end

function M.rootDir(files)
    local found = vim.fs.find(files, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
    if found then
        return vim.fs.dirname(found)
    end
    return nil
end

function M.supplyArguments()
    local defaultArgs = ""
    if vim.g.dap_arguments then
        defaultArgs = vim.g.dap_arguments
    end
    local args = vim.fn.input({
        prompt = "Arguments: ",
        default = defaultArgs,
    })
    vim.g.dap_arguments = args
    if args == "" then
        return nil
    end
    return vim.split(args, " ")
end

return M
