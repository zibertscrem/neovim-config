local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<esc>"] = actions.close,
            },
        },
    },
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>pgf", builtin.git_files, {})
vim.keymap.set("n", "<leader>pgb", builtin.git_branches, {})
vim.keymap.set("n", "<leader>pgs", builtin.git_stash, {})
vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
vim.keymap.set("n", "<leader>pv", builtin.treesitter, {})
vim.keymap.set("n", "<leader>pq", builtin.quickfix, {})
vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
vim.keymap.set("n", "<leader>pm", builtin.marks, {})
