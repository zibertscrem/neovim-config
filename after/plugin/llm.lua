local cmp_ai = require("cmp_ai.config")

cmp_ai:setup({
	max_lines = 100,
	max_timeout_seconds = 8,
	provider = "Ollama",
	provider_options = {
		model = "codellama:7b-code",
		base_url = "http://ollama.ai.lan:11434/api/generate",
		auto_unload = false, -- Set to true to automatically unload the model when
		-- exiting nvim.
	},
	notify = true,
	notify_callback = function(msg)
		-- vim.notify(msg)
	end,
	log_errors = true,
	run_on_every_keystroke = false,
	ignored_file_types = {
		-- default is not to ignore
		-- uncomment to ignore in lua:
		lua = true,
	},
})
