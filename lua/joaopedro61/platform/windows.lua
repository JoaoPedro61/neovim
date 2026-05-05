local M = {}

--- Configures clipboard integration for Windows.
function M.setup()
  vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })
end

return M
