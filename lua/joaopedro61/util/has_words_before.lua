--- Checks whether the character before the cursor is non-whitespace.
---
--- @return boolean has_words `true` when completion has word context before the cursor.
local function has_words_before()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local col = cursor[2]

  if col == 0 then
    return false
  end

  local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1] or ""
  return current_line:sub(col, col):match("%s") == nil
end

return has_words_before
