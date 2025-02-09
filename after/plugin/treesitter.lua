require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = "all",

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
        disable = function(_, bufnr)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
    },
})
vim.treesitter.language.register("html", "gohtmltmpl")

require("treesitter-context").setup({
    enable = true,
    separator = "-",
})
require("treesitter_indent_object").setup()

-- select context-aware indent
vim.keymap.set({"x", "o"}, "ai", function() require'treesitter_indent_object.textobj'.select_indent_outer() end)
-- ensure selecting entire line (or just use Vai)
vim.keymap.set({"x", "o"}, "aI", function() require'treesitter_indent_object.textobj'.select_indent_outer(true) end)
-- select inner block (only if block, only else block, etc.)
vim.keymap.set({"x", "o"}, "ii", function() require'treesitter_indent_object.textobj'.select_indent_inner() end)
-- select entire inner range (including if, else, etc.) in line-wise visual mode
vim.keymap.set({"x", "o"}, "iI", function() require'treesitter_indent_object.textobj'.select_indent_inner(true, 'V') end)

vim.keymap.set("n", "<leader>fc", function()
    require("treesitter-context").toggle()
end)

vim.keymap.set({"n", "v"}, "<leader>gc", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end)
