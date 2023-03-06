local setup = require("taboo.setup")
local M = {}

-- close the preview buffers
M.close = function(buffers)
	vim.api.nvim_buf_delete(buffers.left, { force = true })
	vim.api.nvim_buf_delete(buffers.right, { force = true })
end

M.enrich_preview = function(buffers)
	M._enrich_left_buffer(buffers.left)
end

M.reload = function(left_bufnr, right_bufnr)
	local linepos = M._get_cursor_line(left_bufnr)
	local tabnr = M._get_line_content(left_bufnr, linepos)
	local buffers = M._get_buffers_by_tab(tabnr)
	local filenames = M._get_buffer_filenames(buffers)
	vim.api.nvim_buf_set_lines(right_bufnr, 0, -1, true, filenames)
end

-- ------- --
-- HELPERS --
-- ------- --

M._get_buffer_filenames = function(buffers)
	local lines = {}
	for _, buffer in pairs(buffers) do
		table.insert(lines, buffer.bufname)
	end
	return lines
end

M._enrich_left_buffer = function(bufnr)
	local tabs = vim.fn.gettabinfo()
	local lines = {}
	for _, tab in pairs(tabs) do
		table.insert(lines, tostring(tab.tabnr))
	end
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
end

M._get_cursor_line = function(bufnr)
	local current_win = vim.api.nvim_get_current_win()
	local cursor_pos = vim.api.nvim_win_get_cursor(current_win)
	if vim.api.nvim_buf_is_valid(bufnr) then
		local cursor_line = cursor_pos[1]
		return cursor_line
	else
		return nil
	end
end

M._get_line_content = function(bufnr, line_number)
	local lines = vim.api.nvim_buf_get_lines(bufnr, line_number - 1, line_number, false)
	if #lines > 0 then
		return tonumber(lines[1])
	else
		return nil
	end
end

M._get_buffers_by_tab = function(tabnr)
	local wins = vim.api.nvim_list_wins()
	local buffers = {}
	for _, winid in ipairs(wins) do
		local win_tabnr = vim.api.nvim_win_get_tabpage(winid)
		if win_tabnr == tabnr then
			local bufnr = vim.api.nvim_win_get_buf(winid)
			local bufname = vim.fn.bufname(bufnr)
			if bufname ~= "" then
				table.insert(buffers, { bufnr = bufnr, bufname = bufname })
			end
		end
	end
	return buffers
end

return M
