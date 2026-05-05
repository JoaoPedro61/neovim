local M = {}

--- Reads and decodes a JSON file.
---
--- @param path string File path to read.
--- @return table? data Decoded JSON table, or `nil` on read/decode failure.
function M.read(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local data = file:read("*a")
  file:close()

  local ok, decoded = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
  if ok and decoded then
    return decoded
  end

  return nil
end

--- Encodes a Lua table and writes it as JSON.
---
--- @param path string File path to write.
--- @param data table Data encoded as JSON.
--- @return boolean ok `true` when the write succeeds.
function M.write(path, data)
  local file = io.open(path, "w")
  if not file then
    return false
  end

  file:write(vim.json.encode(data))
  file:close()

  return true
end

return M
