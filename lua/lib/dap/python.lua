local dap = require("dap")
local utils = require("lib.dap.utils")

local M = {}

local function projectRoot()
    return utils.root_dir({
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "poetry.toml",
    }) or vim.fn.getcwd()
end
local function pythonPath()
    -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
    -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
    -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
    local poetryPython = vim.fn.system({ "poetry", "env", "info", "-e" })
    if vim.fn.executable(poetryPython) == 1 then
        return poetryPython
    end
    local root = projectRoot()
    if vim.fn.executable(root .. "/venv/bin/python") == 1 then
        return root .. "/venv/bin/python"
    end
    if vim.fn.executable(root .. "/.venv/bin/python") == 1 then
        return root .. "/.venv/bin/python"
    end
    return "python"
end
local function supplyArguments()
    local defaultArgs = ""
    if vim.b.dap_python_arguments then
        defaultArgs = vim.b.dap_python_arguments
    end
    local args = vim.fn.input({
        prompt = "Arguments: ",
        default = defaultArgs,
    })
    vim.b.dap_python_arguments = args
    if args == "" then
        return nil
    end
    return vim.split(args, " ")
end
local function getCurrentModulePath()
    return vim.fn.expand("%:h:gs?/?.?")
end
local function supplyModulePath()
    local defaultModule = ""
    if vim.g.dap_python_module then
        defaultModule = vim.g.dap_python_module
    end
    local module = vim.fn.input({
        prompt = "Module: ",
        default = defaultModule,
    })
    module = vim.trim(module)
    vim.g.dap_python_module = module
    return module
end
M.adapter = function(cb, config)
    if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
                source_filetype = "python",
            },
        })
    else
        cb({
            type = "executable",
            command = utils.mason_package_path("debugpy") .. "/venv/bin/python",
            args = { "-m", "debugpy.adapter" },
            options = {
                source_filetype = "python",
            },
        })
    end
end

M.configuration = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}", -- This configuration will launch the current file if used.
        args = supplyArguments,
        cwd = projectRoot,
        pythonPath = pythonPath,
    },
    {
        type = "python",
        request = "launch",
        name = "Launch module",
        module = getCurrentModulePath,
        args = supplyArguments,
        cwd = projectRoot,
        pythonPath = pythonPath,
    },
}

return M
