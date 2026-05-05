--- Sets a value in a nested table using a dot-separated path.
---
--- Intermediate tables are created as needed. When both the current value and
--- new value are tables, `override = false` merges keys instead of replacing.
---
--- @generic T
--- @param root table Table to update.
--- @param path string Dot-separated path.
--- @param value T Value to set.
--- @param override? boolean Replace table values instead of merging them.
--- @return T|table|nil value Value stored at the path, or `nil` when the path is invalid.
local function deep_set(root, path, value, override)
  if type(root) ~= "table" then
    return nil
  end

  local keys = vim.split(path, ".", { plain = true })
  local target = root

  for index = 1, #keys - 1 do
    local key = keys[index]

    if type(target) ~= "table" then
      return nil
    end

    if target[key] == nil then
      target[key] = {}
    elseif type(target[key]) ~= "table" then
      return nil
    end

    target = target[key]
  end

  local last_key = keys[#keys]
  if not last_key or last_key == "" or type(target) ~= "table" then
    return nil
  end

  local current = target[last_key]

  if not override and type(current) == "table" and type(value) == "table" then
    for key, item in pairs(value) do
      current[key] = item
    end

    return current
  end

  target[last_key] = value
  return target[last_key]
end

return deep_set
