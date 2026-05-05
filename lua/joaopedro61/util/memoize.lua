--- @alias joaopedro61.Util.MemoizeCache table<function, table<string, any>>

local memoize_cache = {} --- @type joaopedro61.Util.MemoizeCache

--- Memoizes a function using `vim.inspect` of the arguments as the cache key.
---
--- @generic T: function
--- @param fn T Function to memoize.
--- @return T memoized Function wrapper with cached results.
local function memoize(fn)
  local function wrapper(...)
    local key = vim.inspect({ ... })
    memoize_cache[fn] = memoize_cache[fn] or {}
    if memoize_cache[fn][key] == nil then
      memoize_cache[fn][key] = fn(...)
    end
    return memoize_cache[fn][key]
  end

  return wrapper
end

return memoize
