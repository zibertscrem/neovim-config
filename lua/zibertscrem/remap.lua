vim.g.mapleader = " "
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>")

vim.keymap.set("n", "<C-w><C-v>", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<C-w><C-s>", "<cmd>split<CR>")

vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<CR>")
vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<CR>")
vim.keymap.set("t", "<C-w>", "<C-\\><C-N><C-w>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "\"", "c\"\"<Esc>P")
vim.keymap.set("v", "\'", "c\'\'<Esc>P")
vim.keymap.set("v", "(", "c()<Esc>P")
vim.keymap.set("v", "[", "c[]<Esc>P")
vim.keymap.set("v", "<", "c<><Esc>P")
vim.keymap.set("v", "{", "c{}<Esc>P")


vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>wc", "<cmd>%s/\\r//g<CR>", { silent = true })

vim.keymap.set("n", "<leader>n", "<cmd>bnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>m", "<cmd>bprev<CR>", { silent = true })
vim.keymap.set("n", "<leader>d", "<cmd>bdelete<CR>", { silent = true })
