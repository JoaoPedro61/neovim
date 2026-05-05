local platform = require("joaopedro61.util.platform")

local M = {}

--- Returns the platform module name that should be applied.
---
--- @return string? name Platform module suffix.
function M.detect()
  if platform.is_wsl() then
    return "wsl"
  end

  if platform.is_windows() then
    return "windows"
  end

  if platform.is_macos() then
    return "macos"
  end

  if platform.is_linux() then
    return "linux"
  end

  return nil
end

--- Applies platform-specific settings.
---
--- @return string? name Applied platform module suffix.
function M.setup()
  local name = M.detect()
  if not name then
    return nil
  end

  require("joaopedro61.platform." .. name).setup()
  return name
end

M.setup()

return M
