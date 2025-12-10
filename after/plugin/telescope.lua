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
vim.keymap.set("n", "<leader>ff", builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>ph", function()
	builtin.find_files({ hidden = true })
end, {})
vim.keymap.set("n", "<leader>pif", function()
	builtin.find_files({ no_ignore = true })
end, {})
vim.keymap.set("n", "<leader>pip", function()
	builtin.find_files({ no_ignore = true, no_parent_ignore = true })
end, {})
vim.keymap.set("n", "<leader>pgf", builtin.git_files, {})
vim.keymap.set("n", "<leader>pgb", builtin.git_branches, {})
vim.keymap.set("n", "<leader>pgs", builtin.git_stash, {})
vim.keymap.set("n", "<leader>pgq", builtin.git_status, {})
vim.keymap.set("n", "<leader>pgc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>fgc", builtin.git_bcommits, {})
vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
vim.keymap.set("n", "<leader>pv", builtin.treesitter, {})
vim.keymap.set("n", "<leader>pq", builtin.quickfix, {})
vim.keymap.set("n", "<leader>pb", builtin.buffers, {})
vim.keymap.set("n", "<leader>pm", builtin.marks, {})
vim.keymap.set("n", "<leader>pj", builtin.jumplist, {})
vim.keymap.set("n", "<leader>pl", builtin.loclist, {})
