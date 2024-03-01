local mason_path = require("mason-core.path")
local M = {}

function M.mason_package_path(pkg)
    return mason_path.package_prefix(pkg)
end

function M.root_dir(files)
    local found = vim.fs.find(files, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
    if found then
        return vim.fs.dirname(found)
    end
    return nil
end

return M
