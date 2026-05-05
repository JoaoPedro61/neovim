local M = {}

--- Configures clipboard integration for Linux.
function M.setup()
  vim.opt.clipboard:append({ "unnamedplus" })
end

return M
