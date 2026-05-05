--- @generic T
---
--- @param target table Table that contains the destination list.
--- @param key string Dot-separated path to the destination list.
--- @param source T[] Values appended to the destination list.
--- @return T[]? target Destination list after extension.
local function extend(target, key, source)
  if type(target) ~= "table" or type(source) ~= "table" then
    return
  end

  local keys = vim.split(key, ".", { plain = true })

  for i = 1, #keys do
    local k = keys[i]

    if type(target) ~= "table" then
      return
    end

    target[k] = target[k] or {}
    target = target[k]
  end

  if type(target) ~= "table" then
    return
  end

  return vim.list_extend(target, source)
end

return extend
