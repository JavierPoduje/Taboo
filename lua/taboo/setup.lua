local M = {}

local definitions = {
	mappings = {
		n = {
			["<Esc>"] = ':lua require("taboo.commands").close()<CR>',
			["<C-c>"] = ':lua require("taboo.commands").close()<CR>',
			["<CR>"] = ':lua require("taboo.commands").select()<CR>',
			["dd"] = ':lua require("taboo.commands").remove()<CR>',
		},
	},
	config = {
		windows = {
			left = {
				width = 2,
			},
			right = {
				width = 40,
			},
			height = 25,
		},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	},
}

return setmetatable(M, {
	__index = function(_, k)
		return definitions[k]
	end,
})
