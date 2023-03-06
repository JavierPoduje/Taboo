vim = vim

local M = {}

local taboo_group = vim.api.nvim_create_augroup("Taboo", { clear = true })

-- clean when the preview is close
vim.api.nvim_create_autocmd({ "BufLeave, VimLeave" }, {
	callback = function()
		require("taboo.utils").clean()
	end,
	group = taboo_group,
})

M.hi = function()
	print("hi!")
end

-- Sets the commands
vim.cmd('command! TabooOpen lua require("taboo.commands").open_preview()')
vim.cmd('command! TabooClose lua require("taboo.commands").close()')

return M
