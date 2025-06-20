local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
	},
	{
		"nvim-lua/plenary.nvim",
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		"mbbill/undotree",
		tag = "rel_6.1",
	},
	{ "tpope/vim-fugitive" },
	{ "idanarye/vim-merginal" },
	{
		"akinsho/toggleterm.nvim",
		tag = "v2.9.0",
		config = true,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
	},
	{ "neovim/nvim-lspconfig" },
	{
		"williamboman/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
			},
		},
	},
	{ "williamboman/mason-lspconfig.nvim" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "L3MON4D3/LuaSnip" },
	{ "hrsh7th/cmp-nvim-lua" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "rafamadriz/friendly-snippets" },
	{
		"numToStr/Comment.nvim",
		opts = {},
		tag = "v0.8.0",
		lazy = false,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
	},
	{ "mfussenegger/nvim-lint" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{
		"venomlab/goimpl.nvim",
		tag = "0.1.0",
	},
	{ "derektata/lorem.nvim" },
	{ "mfussenegger/nvim-dap" },
	{ "theHamsta/nvim-dap-virtual-text" },
	{
		"nvim-neotest/nvim-nio",
	},
	{
		"rcarriga/nvim-dap-ui",
	},
	{
		"mfussenegger/nvim-jdtls",
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-python",
			"rcasia/neotest-java",
			"nvim-neotest/neotest-go",
			{
				"lawrence-laz/neotest-zig",
				branch = "main",
			},
			{
				"mrcjkb/rustaceanvim",
				version = "^6", -- Recommended
				lazy = false, -- This plugin is already lazy
			},
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"https://github.com/nvim-treesitter/nvim-treesitter-context",
	},
	{
		"nvim-lualine/lualine.nvim",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
	},
	{
		"kiyoon/treesitter-indent-object.nvim",
	},
	{
		"hiphish/rainbow-delimiters.nvim",
	},
})
