vim.keymap.set("n", "<leader>fc", function()
    require("treesitter-context").toggle()
end)

vim.keymap.set({"n", "v"}, "<leader>gc", function()
    require("treesitter-context").go_to_context(vim.v.count1)
end)
