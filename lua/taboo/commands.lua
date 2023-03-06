local popup = require("plenary.popup")

local setup = require("taboo.setup")
local api = require('taboo.api')

local M = {
	buffers = {
		left = -1,
		right = -1,
	}
}

M.open_preview = function()
	local left_bufnr = vim.api.nvim_create_buf(false, false)
	local right_bufnr = vim.api.nvim_create_buf(false, false)

	local lwidth = setup.config.windows.left.width
	local rwidth = setup.config.windows.right.width
	local height = setup.config.windows.height

	local total_width = lwidth + rwidth

	popup.create(left_bufnr, {
		border = {},
		title = false,
		highlight = "PickersHighlight",
		borderhighlight = "PickersBorder",
		enter = true,
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - lwidth) / 2),
		minwidth = lwidth,
		minheight = height,
		borderchars = setup.config.borderchars,
	}, false)
	popup.create(right_bufnr, {
		border = {},
		title = "~ Taboo ~",
		highlight = "PreviewHighlight",
		borderhighlight = "PreviewBorder",
		enter = false,
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor(((vim.o.columns - total_width) + rwidth + 7) / 2),
		minwidth = rwidth,
		minheight = height,
		borderchars = setup.config.borderchars,
	}, false)

	M.buffers.left = left_bufnr
	M.buffers.right = right_bufnr

	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = M.buffers.left,
		callback = function()
			api.reload(M.buffers.left, M.buffers.right)
		end,
	})

	api.enrich_preview(M.buffers)
end

-- close the preview
M.close = function()
	api.close(M.buffers)
end

-- select a tab by id
M.select = function() end

-- remove a tab by id
M.remove = function() end

-- reload the preview after a movement
M.reload = function() end

return M
