local popup = require("plenary.popup")
local setup = require("taboo.setup")

local M = {}

-- close the preview buffers
M.close_preview = function(buffers)
	vim.api.nvim_buf_delete(buffers.left, { force = true })
	vim.api.nvim_buf_delete(buffers.right, { force = true })
end

M.select = function(buffers)
	local linepos = M._get_cursor_line(buffers.left)
	local tabnr = M._get_tabnr_by_linenr(buffers.left, linepos)

	M.close_preview(buffers)

	local tabid = M._get_tabid_by_tabnr(tabnr)
	vim.api.nvim_set_current_tabpage(tabid)
end

M.enrich_preview = function(buffers)
	M._reload_left_buffer_content(buffers)
end

M.remove = function(buffers)
	-- don't delete if there's only one tab available
	local tabs = vim.fn.gettabinfo()
	if #tabs == 1 then
		print("can't remove the only remaining tab")
		return
	end

	-- do the deletion
	local linepos = M._get_cursor_line(buffers.left)
	local tabnr = M._get_tabnr_by_linenr(buffers.left, linepos)

	if tabnr == nil then
		print("invalid tabnr")
		return
	end

	vim.api.nvim_command(tabnr .. "tabclose")

	vim.schedule(function()
		vim.cmd(":TabooClose")
		vim.cmd(":TabooOpen")
	end)
end

M.open_preview = function()
	local left_bufnr = vim.api.nvim_create_buf(false, false)
	local right_bufnr = vim.api.nvim_create_buf(false, false)

	local lwidth = setup.size.left.width
	local rwidth = setup.size.right.width
	local height = setup.size.height

	local total_width = lwidth + rwidth
	local borders = 2
	local left_col = math.floor((vim.o.columns / 2) - (total_width / 2))
	local top_row = math.floor(((vim.o.lines - height) / 2) - 1)

	popup.create(left_bufnr, {
		border = {},
		title = false,
		highlight = "LeftHighlight",
		borderhighlight = "LeftBorder",
		enter = true,
		line = top_row,
		col = left_col,
		minwidth = lwidth,
		minheight = height,
		borderchars = setup.borders,
	}, false)
	popup.create(right_bufnr, {
		border = {},
		title = "~ Taboo ~",
		highlight = "PreviewHighlight",
		borderhighlight = "PreviewBorder",
		enter = false,
		line = top_row,
		col = left_col + lwidth + borders,
		minwidth = rwidth,
		minheight = height,
		borderchars = setup.borders,
	}, false)

	return { left_bufnr = left_bufnr, right_bufnr = right_bufnr }
end

M.reload_on_cursor_move = function(buffers)
	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = buffers.left,
		callback = function()
			M._reload_right_buffer_content(buffers)
		end,
	})
end

-- ------- --
-- HELPERS --
-- ------- --

M._reload_right_buffer_content = function(buffers)
	local left_bufnr = buffers.left
	local right_bufnr = buffers.right

	local linepos = M._get_cursor_line(left_bufnr)
	local tabnr = M._get_tabnr_by_linenr(left_bufnr, linepos)
	local tab_buffers = M._get_buffers_by_tab(tabnr)
	local filenames = M._get_buffer_filenames(tab_buffers)

	vim.api.nvim_buf_set_lines(right_bufnr, 0, -1, true, filenames)
end

M._get_buffer_filenames = function(buffers)
	local lines = {}
	for _, buffer in pairs(buffers) do
		table.insert(lines, buffer.bufname)
	end
	return lines
end

M._reload_left_buffer_content = function(buffers)
	local bufnr = buffers.left
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

M._get_tabid_by_tabnr = function(tabnr)
	local tabsinfo = vim.fn.gettabinfo(tabnr)
	if #tabsinfo == 0 then
		return {}
	end

	local tab = tabsinfo[1]

	if #tab.windows == 0 then
		return {}
	end

	local window = tab.windows[1]
	return vim.api.nvim_win_get_tabpage(window)
end

M._get_tabnr_by_linenr = function(bufnr, linenr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)
	return tonumber(lines[1])
end

-- get the buffers of a tab by tab number
M._get_buffers_by_tab = function(tabnr)
	local tabsinfo = vim.fn.gettabinfo(tabnr)

	if #tabsinfo == 0 then
		return {}
	end

	local tab = tabsinfo[1]

	if #tab.windows == 0 then
		return {}
	end

	local wins = tab.windows
	local buffers = {}
	for _, winid in ipairs(wins) do
		local bufnr = vim.api.nvim_win_get_buf(winid)

		local bufname = M._get_bufname(bufnr)
		local current_path = vim.fn.expand("%:p:h")

		if bufname ~= "" and bufname ~= current_path .. "/" then
			table.insert(buffers, { bufnr = bufnr, bufname = bufname })
		end
	end

	return buffers
end

M._get_bufname = function(bufnr)
	local bufname = vim.fn.bufname(bufnr)
	local current_path = vim.fn.expand("%:p:h")
	local git_directory = current_path .. "/.git"
	local git_directory_exists = io.open(git_directory, "r") ~= nil

	-- if the user is using git, remove the path to the project from the bufnames
	if git_directory_exists then
		local pattern = "^" .. current_path
		return string.gsub(bufname, pattern, "")
	end

	-- if the current_path is already included in the bufname,
	-- just return the raw bufname
	if current_path ~= "" and current_path ~= "/" and string.match(bufname, current_path) ~= nil then
		return bufname
	end

	if string.sub(current_path, -1) == "/" then
		return current_path .. bufname
	else
		return current_path .. "/" .. bufname
	end
end

M.set_mappings = function(left_bufnr)
	for key_bind in pairs(setup.mappings) do
		local cb = setup.mappings[key_bind]
		vim.api.nvim_buf_set_keymap(left_bufnr, "n", key_bind, cb, { silent = true })
	end
end

M.merge_table_impl = function(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k]) == "table" then
				M.merge_table_impl(t1[k], v)
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
end

return M
