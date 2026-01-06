require("cursor-agent").setup({})

-- Toggle the interactive terminal
vim.keymap.set("n", "<leader>csa", ":CursorAgent<CR>", { desc = "Cursor Agent: Toggle terminal" })
-- -- Ask about the visual selection
vim.keymap.set("v", "<leader>csa", ":CursorAgentSelection<CR>", { desc = "Cursor Agent: Send selection" })
-- -- Ask about the current buffer
vim.keymap.set("n", "<leader>csA", ":CursorAgentBuffer<CR>", { desc = "Cursor Agent: Send buffer" })
