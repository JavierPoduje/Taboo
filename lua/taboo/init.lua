vim = vim

-- Set the commands
vim.cmd('command! TabooOpen lua require("taboo.commands").open_preview()')
vim.cmd('command! TabooClose lua require("taboo.commands").close_preview()')
vim.cmd('command! TabooSelect lua require("taboo.commands").select()')
