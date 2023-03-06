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

-- Sets the commands
vim.cmd('command! TabooOpen lua require("taboo.commands").open_preview()')
vim.cmd('command! TabooClose lua require("taboo.commands").close()')

vim.api.nvim_set_keymap('n', '<leader>to', ':TabooOpen<cr>', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>tp', ':TabooClose<cr>', { noremap = true, silent = false })

return M
