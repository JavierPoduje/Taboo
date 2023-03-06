vim = vim

local M = {}

-- Sets the commands
vim.cmd('command! TabooOpen lua require("taboo.commands").open_preview()')
vim.cmd('command! TabooClose lua require("taboo.commands").close()')
vim.cmd('command! TabooSelect lua require("taboo.commands").select()')

vim.api.nvim_set_keymap('n', '<leader>to', ':TabooOpen<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tp', ':TabooClose<cr>', { noremap = true, silent = true })

return M
