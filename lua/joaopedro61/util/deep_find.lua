--- Finds a value in a nested table using a dot-separated path.
---
--- @generic T
--- @param root table Table to search.
--- @param path string Dot-separated path.
--- @param or_value T Fallback returned when the path cannot be resolved.
--- @return T|any value Found value or `or_value`.
local function deep_find(root, path, or_value)
  local keys = vim.split(path, ".", { plain = true })
  local target = root

  for _, key in ipairs(keys) do
    if type(target) ~= "table" or target[key] == nil then
      return or_value
    end

    target = target[key]
  end

  return target
end

return deep_find
