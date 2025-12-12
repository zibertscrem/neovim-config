local lsp_zero = require("lsp-zero")
local cmp = require("cmp")
local telescope_builtin = require("telescope.builtin")

local function on_attach(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "gd", function()
		telescope_builtin.lsp_definitions()
	end, opts)
	vim.keymap.set("n", "gD", function()
		telescope_builtin.lsp_type_definitions()
	end, opts)
	vim.keymap.set("n", "gi", function()
		telescope_builtin.lsp_implementations()
	end, opts)
	vim.keymap.set("n", "gI", function()
		telescope_builtin.lsp_incoming_calls()
	end, opts)
	vim.keymap.set("n", "gO", function()
		telescope_builtin.lsp_outgoing_calls()
	end, opts)

	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)

	vim.keymap.set("n", "<leader>ws", function()
		telescope_builtin.lsp_workspace_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fs", function()
		telescope_builtin.lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fd", function()
		-- Document diagnostics
		telescope_builtin.diagnostics({ bufnr = 0 })
	end, opts)
	vim.keymap.set("n", "<leader>wd", function()
		-- Workspace diagnostics
		telescope_builtin.diagnostics()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = 1, severity = "ERROR", float = true, wrap = true })
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.jump({ count = -1, severity = "ERROR", float = true, wrap = true })
	end, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vr", function()
		vim.lsp.buf.references({ includeDeclaration = false }, {
			on_list = function(options)
				vim.fn.setqflist({}, " ", options)
				telescope_builtin.quickfix()
			end,
		})
	end, opts)
	vim.keymap.set("n", "<leader>vn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
	vim.keymap.set("n", "<leader>rs", function()
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		vim.lsp.stop_client(clients, true)
		for _, client in ipairs(clients) do
			local buffers = client.attached_buffers
			client.stop(true)
			for buf, is_active in pairs(buffers) do
				if is_active then
					vim.lsp.start(client.config, { bufnr = buf })
				end
			end
		end
	end, opts)
	local goimpl = require("goimpl")
	if goimpl.is_go() then
		vim.keymap.set("n", "<leader>im", function()
			goimpl.impl()
		end, opts)
	end
end

lsp_zero.on_attach(on_attach)
require("lspconfig").mojo.setup({
	on_attach = on_attach,
})

if os.getenv("WSL_DISTRO_NAME") ~= nil then -- Easy way to check if it is WSL or no
	require("lspconfig").gdscript.setup({
		on_attach = on_attach, -- Your buffer on_attach function
		cmd = { "godot-wsl-proxy", "run" },
	})
else
	require("lspconfig").gdscript.setup({
		on_attach = on_attach, -- Your buffer on_attach function
	})
end

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		-- LSPs
		"rust_analyzer",
		-- "pylsp",
		"basedpyright",
		"ruff",
		"lua_ls",
		"gopls",
		"zls",
		"docker_compose_language_service",
		"dockerls",
		"marksman",
		"sqlls",
		"html",
		"htmx",
		"jdtls",
	},
	automatic_installation = true,
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			require("neodev").setup({})
			local lua_opts = lsp_zero.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
		gopls = function()
			local go_opts = {
				cmd = { "gopls", "-remote=auto" },
				-- attach to new filetypes too.
				filetypes = { "go", "gomod", "gowork", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
				settings = {
					gopls = {
						-- see ftdetect/go.lua.
						["build.templateExtensions"] = { "gohtml", "html", "gotmpl", "tmpl", "go.html", "go.tmpl" },
					},
				},
				-- rest of your config.
			}
			require("lspconfig").gopls.setup(go_opts)
		end,
		jdtls = function() end,
		rust_analyzer = function() end,
	},
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
	sources = {
		{ name = "luasnip", keyword_length = 2 },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "nvim_lua" },
		{ name = "buffer", keyword_length = 3 },
	},
	formatting = lsp_zero.cmp_format(),
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
		["<C-i>"] = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
		["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-x>"] = cmp.mapping(
			cmp.mapping.complete({
				config = {
					sources = cmp.config.sources({
						{ name = "cmp_ai" },
					}),
				},
			}),
			{ "i" }
		),
		["<C-q>"] = cmp.mapping.close(),
	}),
})
