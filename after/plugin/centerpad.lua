vim.keymap.set("n", "<leader>z", function()
	local centerpad = require("centerpad")
	centerpad.toggle({ leftpad = 60, rightpad = 0 })
end, { silent = true, noremap = true })
