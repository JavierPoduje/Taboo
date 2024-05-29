local api = require("taboo.api")

local M = {
	_buffers = {
		left = -1,
		right = -1,
	},
}

M.open_preview = function()
	local bufs = api.open_preview()

	M._buffers.left = bufs.left_bufnr
	M._buffers.right = bufs.right_bufnr

  vim.api.nvim_buf_set_option(M._buffers.left, "bufhidden", "delete")
  vim.api.nvim_buf_set_option(M._buffers.left, "filetype", "taboo")
  vim.api.nvim_buf_set_option(M._buffers.right, "bufhidden", "delete")
  vim.api.nvim_buf_set_option(M._buffers.right, "filetype", "taboo")


	api.set_mappings(M._buffers.left)
	api.enrich_preview(M._buffers)
	api.reload_on_cursor_move(M._buffers)
end

-- close the preview
M.close_preview = function()
	if M._buffers.left == -1 or M._buffers.right == -1 then
		print("No Taboo preview to close")
		return
	end

	local left_bufnr = M._buffers.left
	local right_bufnr = M._buffers.right

	M._buffers.left = -1
	M._buffers.right = -1

	api.close_preview({ left = left_bufnr, right = right_bufnr })
end

-- select a tab by id
M.select = function()
	api.select(M._buffers)
	M._buffers.left = -1
	M._buffers.right = -1
end

-- remove a tab by id
M.remove = function()
	api.remove(M._buffers)
end

return M
