--- Returns the directory of the current buffer.
---
--- @return string dir Absolute directory path for the current buffer.
local function buffer_dir()
  return vim.fn.expand("%:p:h")
end

return buffer_dir
