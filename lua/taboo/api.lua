local M = {}

-- close the preview buffers
M.close = function(buffers)
	vim.api.nvim_buf_delete(buffers.left, { force = true })
	vim.api.nvim_buf_delete(buffers.right, { force = true })
end

M.enrich_preview = function(buffers)
	M._enrich_left_buffer(buffers.left)
end

M._enrich_left_buffer = function(bufnr)
	local tabs = vim.fn.gettabinfo()
	local lines = {}
	for _, tab in pairs(tabs) do
		table.insert(lines, tostring(tab.tabnr))
	end
	P(lines)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
end

return M
