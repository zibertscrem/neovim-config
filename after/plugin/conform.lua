local conform = require("conform")
local fmt_opts = {
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
	format_on_save = fmt_opts,
})

vim.keymap.set({ "n", "v" }, "<leader>vf", function()
	conform.format(fmt_opts)
end)
