local conform = require("conform")
local conform_util = require("conform.util")
local lint = require("lint")

local conform_opts = {
    timeout_ms = 1500,
    async = false,
    lsp_fallback = "always",
}
conform.setup({
    formatters_by_ft = {
        python = {
            { "poetry_pyupgrade" },
            { "poetry_isort",    "isort" },
            { "poetry_black",    "black" },
        },
        sql = { "sql_formatter" },
        lua = { "stylua" },
        java = { "google-java-format" },
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
    format_on_save = function(bufnr)
        if vim.g.enable_autoformat == nil and vim.b[bufnr].enable_autoformat then
            return conform_opts
        end
        if vim.b[bufnr].enable_autoformat == nil and vim.g.enable_autoformat then
            return conform_opts
        end
        if vim.g.enable_autoformat and vim.b[bufnr].enable_autoformat then
            return conform_opts
        end
        return nil
    end,
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
                "ppyupgrade",
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
vim.keymap.set("n", "<leader>fg", "<cmd>FormatToggle<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>FormatToggle!<CR>")

vim.api.nvim_create_user_command("FormatToggle", function(args)
    local is_global = not args.bang
    if is_global then
        vim.g.enable_autoformat = not vim.g.enable_autoformat
        if not vim.g.enable_autoformat then
            vim.print("Autoformat on save disabled globally")
        else
            vim.print("Autoformat on save enabled globally")
        end
    else
        vim.b.enable_autoformat = not vim.b.enable_autoformat
        if not vim.b.enable_autoformat then
            vim.print("Autoformat on save disabled for this buffer")
        else
            vim.print("Autoformat on save enabled for this buffer")
        end
    end
end, { desc = "Toggle format-on-save", bang = true })
