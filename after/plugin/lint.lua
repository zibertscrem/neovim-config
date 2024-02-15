local mason_installer = require("mason-tool-installer")
local conform = require("conform")
local lint = require("lint")

mason_installer.setup({
	ensure_installed = {
		"isort",
		"black",
		"stylua",
		"prettier",
		"impl",
	},
})

local conform_opts = {
	timeout_ms = 500,
	async = false,
	lsp_fallback = true,
}
conform.setup({
	formatters_by_ft = {
		python = { "isort", "black" },
		lua = { "stylua" },
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
	format_on_save = conform_opts,
})
lint.linters_by_ft = {
	-- python = { "pflake8", "mypy" },
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
