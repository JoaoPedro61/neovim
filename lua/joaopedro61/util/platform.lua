local has = require("joaopedro61.util.has")

local M = {}

--- Checks whether Neovim is running on Windows.
---
--- @return boolean is_windows `true` on Windows.
function M.is_windows()
  return has("win32")
end

--- Checks whether Neovim is running on macOS.
---
--- @return boolean is_macos `true` on macOS.
function M.is_macos()
  return has("macunix")
end

--- Checks whether Neovim is running on a Unix-like system.
---
--- @return boolean is_unix `true` on Unix-like systems.
function M.is_unix()
  return has("unix")
end

--- Checks whether Neovim is running on Linux.
---
--- @return boolean is_linux `true` on Linux, excluding macOS and WSL.
function M.is_linux()
  return M.is_unix() and not M.is_macos() and not M.is_windows() and not M.is_wsl()
end

--- Checks whether Neovim is running inside WSL.
---
--- @return boolean is_wsl `true` when WSL environment variables are present.
function M.is_wsl()
  return M.is_unix() and os.getenv("WSL_INTEROP") ~= nil
end

return M
