local has = require("joaopedro61.util.has")

local M = {}

--- Checks whether `make` is available in `$PATH`.
---
--- @return boolean available `true` when `make` is executable.
function M.has_make()
  return has("make", true)
end

--- Checks whether `cmake` is available in `$PATH`.
---
--- @return boolean available `true` when `cmake` is executable.
function M.has_cmake()
  return has("cmake", true)
end

--- Checks whether `gmake` is available in `$PATH`.
---
--- @return boolean available `true` when `gmake` is executable.
function M.has_gmake()
  return has("gmake", true)
end

--- Returns the first available build command.
---
--- @return string? command One of `make`, `cmake`, or `gmake`.
function M.get_first_available()
  if M.has_make() then
    return "make"
  end

  if M.has_cmake() then
    return "cmake"
  end

  if M.has_gmake() then
    return "gmake"
  end

  return nil
end

return M
