local width = vim.api.nvim_win_get_width(0) - (vim.api.nvim_win_get_width(0) * 0.15)

return {
	mappings = {
		["<Esc>"] = ':lua require("taboo.commands").close_preview()<CR>',
		["<C-c>"] = ':lua require("taboo.commands").close_preview()<CR>',
		["<CR>"] = ':lua require("taboo.commands").select()<CR>',
		["dd"] = ':lua require("taboo.commands").remove()<CR>',
	},
	size = {
		left = {
			width = 1,
		},
		right = {
			width = width,
		},
		height = math.floor((vim.o.columns - width) / 2),
	},
	borders = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	bufs_names_to_ignore = { "NvimTree", "taboo" },
}
