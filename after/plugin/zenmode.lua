vim.keymap.set("n", "<leader>z", function()
	require("zen-mode").toggle({
		window = {
			width = 0.6, -- width will be 85% of the editor width
		},
	})
end, { silent = true, noremap = true })
