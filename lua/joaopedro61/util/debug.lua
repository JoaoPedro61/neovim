-- selene: allow(global_usage)

local M = {}

--- Returns the first external Lua stack location.
---
--- @return string loc File path and line in `path:line` format.
function M.get_loc()
  local me = debug.getinfo(1, "S")
  local level = 2
  local info = debug.getinfo(level, "S")

  while info and (info.source == me.source or info.source == "@" .. vim.env.MYVIMRC or info.what ~= "Lua") do
    level = level + 1
    info = debug.getinfo(level, "S")
  end

  info = info or me
  local source = info.source:sub(2)
  local uv = vim.uv or vim.loop
  source = uv.fs_realpath(source) or source

  return source .. ":" .. info.linedefined
end

--- Dumps a value through `vim.notify`, including source location context.
---
--- @param value any Value to inspect.
--- @param opts? { loc?: string } Notification options.
function M._dump(value, opts)
  opts = opts or {}
  opts.loc = opts.loc or M.get_loc()

  if vim.in_fast_event() then
    return vim.schedule(function()
      M._dump(value, opts)
    end)
  end

  opts.loc = vim.fn.fnamemodify(opts.loc, ":~:.")
  local msg = vim.inspect(value)

  vim.notify(msg, vim.log.levels.INFO, {
    title = "Debug: " .. opts.loc,
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, "lua") then
        vim.bo[buf].filetype = "lua"
      end
    end,
  })
end

--- Dumps one or more values through `vim.notify`.
---
--- @param ... any Values to inspect.
function M.dump(...)
  local value = { ... }

  if vim.tbl_isempty(value) then
    value = nil
  else
    value = vim.tbl_islist(value) and vim.tbl_count(value) <= 1 and value[1] or value
  end
  M._dump(value)
end

--- Reports extmark counts by namespace and buffer.
function M.extmark_leaks()
  local namespaces = vim.api.nvim_get_namespaces()
  local counts = {}

  for name, namespace in pairs(namespaces) do
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local count = #vim.api.nvim_buf_get_extmarks(buf, namespace, 0, -1, {})

      if count > 0 then
        counts[#counts + 1] = {
          name = name,
          buf = buf,
          count = count,
          ft = vim.bo[buf].ft,
        }
      end
    end
  end

  table.sort(counts, function(a, b)
    return a.count > b.count
  end)

  dd(counts)
end

--- Estimates memory size for a value, recursively walking tables and upvalues.
---
--- @param value any Value whose size should be estimated.
--- @param visited? table<any, true> Values already visited during recursion.
--- @return number bytes Estimated size in bytes.
local function estimate_size(value, visited)
  if value == nil then
    return 0
  end

  visited = visited or {}
  if visited[value] then
    return 0
  end
  visited[value] = true

  local value_type = type(value)
  local bytes = 0

  if value_type == "boolean" then
    bytes = 4
  elseif value_type == "number" then
    bytes = 8
  elseif value_type == "string" then
    bytes = string.len(value) + 24
  elseif value_type == "function" then
    bytes = 32
    local i = 1

    while true do
      local name, val = debug.getupvalue(value, i)

      if not name then
        break
      end

      bytes = bytes + estimate_size(val, visited)
      i = i + 1
    end
  elseif value_type == "table" then
    bytes = 40

    for k, v in pairs(value) do
      bytes = bytes + estimate_size(k, visited) + estimate_size(v, visited)
    end

    local mt = debug.getmetatable(value)

    if mt then
      bytes = bytes + estimate_size(mt, visited)
    end
  end

  return bytes
end

--- Reports estimated loaded module memory grouped by root module.
---
--- @param filter? string Lua pattern used to filter module names.
function M.module_leaks(filter)
  local sizes = {}

  for modname, mod in pairs(package.loaded) do
    if not filter or modname:match(filter) then
      local root = modname:match("^([^%.]+)%..*$") or modname
      sizes[root] = sizes[root] or { mod = root, size = 0 }
      sizes[root].size = sizes[root].size + estimate_size(mod) / 1024 / 1024
    end
  end

  sizes = vim.tbl_values(sizes)

  table.sort(sizes, function(a, b)
    return a.size > b.size
  end)

  dd(sizes)
end

--- Returns an upvalue from a function by name.
---
--- @param func function Function to inspect.
--- @param name string Upvalue name.
--- @return any value Upvalue value, or `nil` when absent.
function M.get_upvalue(func, name)
  local i = 1

  while true do
    local n, v = debug.getupvalue(func, i)

    if not n then
      break
    end

    if n == name then
      return v
    end

    i = i + 1
  end
end

return M
