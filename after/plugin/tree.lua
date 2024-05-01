-- Going to try using both just in case
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    update_focused_file = {
        enable = true,
    },
    filters = {
        custom = {
            "^\\.git$",
            "^__pycache__$",
        },
    },
})
vim.keymap.set("n", "<A-1>", "<cmd>NvimTreeToggle<CR>")
