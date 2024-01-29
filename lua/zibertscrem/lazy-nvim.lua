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
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{ "rose-pine/neovim", name = "rose-pine" },
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	{"mbbill/undotree", tag = "rel_6.1"},
	'tpope/vim-fugitive',
	--- Uncomment the two plugins below if you want to manage the language servers from neovim
	-- {'williamboman/mason.nvim'},
	-- {'williamboman/mason-lspconfig.nvim'},

	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'neovim/nvim-lspconfig'},
	{"williamboman/mason.nvim"},
	{"williamboman/mason-lspconfig.nvim"},
	{'hrsh7th/nvim-cmp'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/cmp-buffer'},
	{'hrsh7th/cmp-path'},
	{'L3MON4D3/LuaSnip'},
	{'hrsh7th/cmp-nvim-lua'},
	{'saadparwaiz1/cmp_luasnip'},
	{'rafamadriz/friendly-snippets'},
})
