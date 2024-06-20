local conform = require("conform")
local lint = require("lint")

local conform_opts = {
    timeout_ms = 1500,
    async = false,
    lsp_fallback = "always",
}
conform.setup({
    formatters_by_ft = {
        python = {},
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
})

vim.keymap.set({ "n", "v" }, "<leader>vf", function()
    conform.format(conform_opts)
end)

lint.linters_by_ft = {
    python = {},
}
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        lint.try_lint()
    end,
})
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
