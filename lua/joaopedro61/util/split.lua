--- Splits a string into a list of non-empty segments.
---
--- @param input string String to split.
--- @param separator? string Plain separator. Defaults to whitespace.
--- @return string[] segments Split segments, without empty entries.
local function split(input, separator)
  if separator == nil then
    return vim.split(input, "%s+", { trimempty = true })
  end

  return vim.split(input, separator, { plain = true, trimempty = true })
end

return split
