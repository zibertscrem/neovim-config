require("nvim-treesitter").setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})
require("nvim-treesitter").install("all")

vim.treesitter.language.register("html", "gohtmltmpl")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

require("treesitter-context").setup({
	enable = true,
	separator = "-",
})
require("treesitter_indent_object").setup()

-- select context-aware indent
vim.keymap.set({ "x", "o" }, "ai", function()
	require("treesitter_indent_object.textobj").select_indent_outer()
end)
-- ensure selecting entire line (or just use Vai)
vim.keymap.set({ "x", "o" }, "aI", function()
	require("treesitter_indent_object.textobj").select_indent_outer(true)
end)
-- select inner block (only if block, only else block, etc.)
vim.keymap.set({ "x", "o" }, "ii", function()
	require("treesitter_indent_object.textobj").select_indent_inner()
end)
-- select entire inner range (including if, else, etc.) in line-wise visual mode
vim.keymap.set({ "x", "o" }, "iI", function()
	require("treesitter_indent_object.textobj").select_indent_inner(true, "V")
end)

vim.keymap.set("n", "<leader>fc", function()
	require("treesitter-context").toggle()
end)

vim.keymap.set({ "n", "v" }, "<leader>gc", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end)
