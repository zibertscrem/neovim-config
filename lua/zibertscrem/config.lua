vim.opt.encoding = "UTF-8"
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "120"

vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.gohtml", "*.go.html" },
    callback = function()
        vim.opt_local.filetype = "gohtmltmpl"
    end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.gotmpl", "*.go.tmpl" },
    callback = function()
        vim.opt_local.filetype = "gotexttmpl"
    end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "go.mod" },
    callback = function()
        vim.opt_local.filetype = "gomod"
    end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "go.work" },
    callback = function()
        vim.opt_local.filetype = "gowork"
    end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "go.sum" },
    callback = function()
        vim.opt_local.filetype = "gosum"
    end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "docker-compose*.yaml", "docker-compose*.yml" },
    callback = function()
        vim.opt_local.filetype = "yaml.docker-compose"
    end,
})
