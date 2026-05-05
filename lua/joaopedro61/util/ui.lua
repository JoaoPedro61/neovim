local M = {}

--- Shared icon names used by UI integrations.
--- For more icons see: https://github.com/2KAbhishek/nerdy.nvim/blob/main/lua/nerdy/icons.lua
M.icons = {
  error = " ",
  warn = " ",
  info = " ",

  dot = "",

  wrench = "",

  tab = "",

  git = {
    branch = "",
    diff = {
      added = " ",
      modified = "󰝤 ",
      removed = " ",
    },
  },

  ia = {
    copilot = "",
  },
}

M.colors = {
  fg = {
    dark = "#bbc2cf",
    light = "#27273b",
  },
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

--- Adds the foreground color for the current background to a highlight table.
---
--- @param base_opts? table Existing highlight options.
--- @return table opts Highlight options with an `fg` field when absent.
function M.colors.foreground(base_opts)
  local fg = M.colors.fg[vim.opt.background:get() or "dark"]
  return vim.tbl_deep_extend("keep", { fg = fg }, base_opts or {})
end

--- Returns the standard rounded border used by floating windows.
--- @return string[] border Border characters in Neovim window order.
function M.get_win_borders()
  return { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
end

--- Returns the standard floating window highlight mapping.
--- @return string highlight Window-local highlight mapping.
function M.get_win_highlight()
  return "Normal:MENU,FloatBorder:BORDER,Search:None,CursorLine:PmenuSel"
end

--- Returns the documentation floating window highlight mapping.
--- @return string highlight Window-local highlight mapping.
function M.get_win_highlight_docs()
  return "Normal:MENU,FloatBorder:BORDER,CursorLine:SELECT,Search:MENU"
end

return M
