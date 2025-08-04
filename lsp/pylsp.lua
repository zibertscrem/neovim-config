return {
	settings = {
		pylsp = {
			plugins = {
				jedi_completion = {
					enabled = true,
					fuzzy = true,
					eager = true,
					include_class_objects = true,
					include_function_objects = true,
				},
				rope_autoimport = {
					enabled = true,
					memory = true,
					completions = {
						enabled = true,
					},
					code_actions = {
						enabled = true,
					},
				},
				ruff = {
					enabled = true,
					formatEnabled = true,
					format = { "UP", "I" },
					extendSelect = { "ALL" },
					extendIgnore = { "CPY", "ANN", "D", "PL", "FA" },
					extendFixable = { "ALL" },
					extendSafeFixes = { "ALL" },
					unsafeFixes = true,
					lineLength = 120,
					preview = true,
				},
				pylsp_mypy = {
					enabled = true,
					live_mode = true,
					strict = true,
				},
				signature = {
					formatter = "ruff",
					line_length = 120,
					memory = true,
				},
				yapf = {
					enabled = false,
				},
			},
		},
	},
}
