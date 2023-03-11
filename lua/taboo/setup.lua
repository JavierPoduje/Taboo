return {
	mappings = {
		["<Esc>"] = ':lua require("taboo.commands").close_preview()<CR>',
		["<C-c>"] = ':lua require("taboo.commands").close_preview()<CR>',
		["<CR>"] = ':lua require("taboo.commands").select()<CR>',
		["dd"] = ':lua require("taboo.commands").remove()<CR>',
	},
	size = {
		left = {
			width = 2,
		},
		right = {
			width = 40,
		},
		height = 25,
	},
	borders = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
}
