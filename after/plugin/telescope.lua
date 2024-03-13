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
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
vim.keymap.set("n", "<leader>pv", builtin.treesitter, {})
vim.keymap.set("n", "<leader>pq", builtin.quickfix, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>pm", builtin.marks, {})
