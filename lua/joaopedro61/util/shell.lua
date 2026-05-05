local platform = require("joaopedro61.util.platform")

--- Returns the current shell executable name.
---
--- @return string? shell Shell basename, or `nil` on Windows or when `$SHELL` is unset.
local function shell()
  if platform.is_windows() then
    return nil
  end

  local shell_path = os.getenv("SHELL")
  if not shell_path or shell_path == "" then
    return nil
  end

  return vim.fn.fnamemodify(shell_path, ":t")
end

return shell
