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

	api.reload_on_cursor_move(M.buffers)
	api.set_mappings(M.buffers.left)
	api.enrich_preview(M.buffers)
end

-- close the preview
M.close = function()
	if M.buffers.left == -1 or M.buffers.right == -1 then
		print("No Taboo preview to close")
		return
	end

	api.close(M.buffers)

	-- reset left and right bufnr to sentinel
	M.buffers.left = -1
	M.buffers.right = -1
end

-- select a tab by id
M.select = function()
	print("not implemented")
end

-- remove a tab by id
M.remove = function()
	print("not implemented")
end

return M
