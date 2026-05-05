--- Checks whether a Vim feature or executable is available.
---
--- @param name string Feature name or executable name.
--- @param executable? boolean When `true`, checks `$PATH` instead of `has()`.
--- @return boolean available `true` when the feature or executable exists.
local function has(name, executable)
  if executable then
    return vim.fn.executable(name) == 1
  end

  return vim.fn.has(name) == 1
end

return has
