local api = require("taboo.api")

local M = {
	buffers = {
		left = -1,
		right = -1,
	},
}

M.open_preview = function()
	local bufs = api.open_preview()
	M.buffers.left = bufs.left_bufnr
	M.buffers.right = bufs.right_bufnr

	api.set_mappings(M.buffers.left)
	api.enrich_preview(M.buffers)
	api.reload_on_cursor_move(M.buffers)
end

-- close the preview
M.close_preview = function()
	if M.buffers.left == -1 or M.buffers.right == -1 then
		print("No Taboo preview to close")
		return
	end

	local left_bufnr = M.buffers.left
	local right_bufnr = M.buffers.right

	M.buffers.left = -1
	M.buffers.right = -1

	api.close_preview({ left = left_bufnr, right = right_bufnr })
end

-- select a tab by id
M.select = function()
	api.select(M.buffers)
	M.buffers.left = -1
	M.buffers.right = -1
end

-- remove a tab by id
M.remove = function()
	api.remove(M.buffers)
end

return M
