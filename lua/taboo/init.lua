local api = require("taboo.api")
vim = vim

local M = {}

-- Sets the commands
vim.cmd('command! TabooOpen lua require("taboo.commands").open_preview()')
vim.cmd('command! TabooClose lua require("taboo.commands").close_preview()')
vim.cmd('command! TabooSelect lua require("taboo.commands").select()')

M.setup = function(config)
	api.setup(config or {})
end

return M
