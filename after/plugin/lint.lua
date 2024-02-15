local mason_installer = require("mason-tool-installer")
local conform = require("conform")
local conform_util = require("conform.util")
local lint = require("lint")

mason_installer.setup({
    ensure_installed = {
        "isort",
        "black",
        "stylua",
        "prettier",
        "impl",
        "sql-formatter",
    },
})

local conform_opts = {
    timeout_ms = 1500,
    async = false,
    lsp_fallback = "always",
}
conform.setup({
    formatters_by_ft = {
        python = {
            -- "poetry_pyupgrade",
            { "poetry_isort", "isort" },
            { "poetry_black", "black" },
        },
        sql = { "sql_formatter" },
        lua = { "stylua" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsx = { "prettier" },
        javascript = { "prettier" },
        less = { "prettier" },
        markdown = { "prettier" },
        scss = { "prettier" },
        typescript = { "prettier" },
        yaml = { "prettier" },
    },
    format_on_save = conform_opts,
    formatters = {
        poetry_black = {
            meta = {
                url = "https://github.com/psf/black",
                description = "The uncompromising Python code formatter.",
            },
            command = "poetry",
            stdin = false,
            inherit = false,
            args = {
                "run",
                "black",
                "--quiet",
                "$FILENAME",
            },
            cwd = conform_util.root_file({
                -- https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file
                "pyproject.toml",
                "poetry.toml",
            }),
            require_cwd = true,
        },
        poetry_isort = {
            meta = {
                url = "https://github.com/PyCQA/isort",
                description =
                "Python utility / library to sort imports alphabetically and automatically separate them into sections and by type.",
            },
            command = "poetry",
            stdin = false,
            inherit = false,
            args = {
                "run",
                "isort",
                "$FILENAME",
            },
            cwd = conform_util.root_file({
                -- https://pycqa.github.io/isort/docs/configuration/config_files.html
                "pyproject.toml",
                "poetry.toml",
            }),
            require_cwd = true,
        },
        poetry_pyupgrade = {
            meta = {
                url = "https://github.com/asottile/pyupgrade",
                description =
                "A tool (and pre-commit hook) to automatically upgrade syntax for newer versions of the language.",
            },
            command = "poetry",
            stdin = false,
            inherit = false,
            args = {
                "run",
                "pyupgrade",
                "--exit-zero-even-if-changed",
                "$FILENAME",
            },
            cwd = conform_util.root_file({
                "pyproject.toml",
                "poetry.toml",
            }),
            require_cwd = true,
        },
    },
})

lint.linters.poetry_pflake8 = {
    cmd = "poetry",
    stdin = true,
    args = {
        "run",
        "pflake8",
        "--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
        "--no-show-source",
        "-",
    },
    ignore_exitcode = true,
    parser = require("lint.parser").from_pattern(
        "[^:]+:(%d+):(%d+):(%w+):(.+)",
        { "lnum", "col", "code", "message" },
        nil,
        {
            ["source"] = "flake8",
            ["severity"] = vim.diagnostic.severity.WARN,
        }
    ),
}

lint.linters.poetry_mypy = {
    cmd = "poetry",
    stdin = false,
    ignore_exitcode = true,
    args = {
        "run",
        "mypy",
        "--show-column-numbers",
        "--show-error-end",
        "--hide-error-codes",
        "--hide-error-context",
        "--no-color-output",
        "--no-error-summary",
        "--no-pretty",
    },
    parser = require("lint.parser").from_pattern(
        "([^:]+):(%d+):(%d+):(%d+):(%d+): (%a+): (.*)",
        { "file", "lnum", "col", "end_lnum", "end_col", "severity", "message" },
        {
            error = vim.diagnostic.severity.ERROR,
            warning = vim.diagnostic.severity.WARN,
            note = vim.diagnostic.severity.HINT,
        },
        { ["source"] = "mypy" },
        { end_col_offset = 0 }
    ),
}
lint.linters_by_ft = {
    python = { "poetry_mypy", "poetry_pflake8" },
}
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        lint.try_lint()
    end,
})
vim.keymap.set({ "n", "v" }, "<leader>vf", function()
    conform.format(conform_opts)
end)
vim.keymap.set({ "n", "v" }, "<leader>vl", function()
    lint.try_lint()
end)
