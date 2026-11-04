-- Create log parents before plugins initialize, including on the first startup.
local log_dir = vim.fn.stdpath("log")
if vim.fn.isdirectory(log_dir) == 0 then
  vim.fn.mkdir(log_dir, "p")
end

