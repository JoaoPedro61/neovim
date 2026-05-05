--- Merges `source` into `target` in place.
---
--- @generic T: table
--- @param target T Table to update.
--- @param source table Values copied into `target`.
--- @return T? target Updated target, or `nil` when either argument is not a table.
local function merge_tables(target, source)
  if type(target) ~= "table" or type(source) ~= "table" then
    return
  end

  for key, value in pairs(source) do
    target[key] = value
  end

  return target
end

return merge_tables
