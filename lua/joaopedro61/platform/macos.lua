local M = {}

--- Configures clipboard integration for macOS.
function M.setup()
  vim.opt.clipboard:append({ "unnamedplus" })
end

return M
