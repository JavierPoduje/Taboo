local M = {}

local definitions = {
	mappings = {
		n = {
			["<Esc>"] = ':lua require("taboo").close()<CR>',
			["<C-c>"] = ':lua require("taboo").close()<CR>',
			["<CR>"] = ':lua require("taboo").select()<CR>',
			["dd"] = ':lua require("taboo").remove()<CR>',
			["j"] = ':lua require("taboo").reload("down")<CR>',
			["k"] = ':lua require("taboo").reload("up")<CR>',
		},
	},
	config = {
		windows = {
			left = {
				width = 3,
			},
			right = {
				width = 80,
			},
			height = 25,
		},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		directions = {
			up = -1,
			down = 1,
		},
	},
}

return setmetatable(M, {
	__index = function(_, k)
		return definitions[k]
	end,
})
