local lint = require("lint")
lint.linters_by_ft = {
	python = { "pflake8", "mypy" },
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
