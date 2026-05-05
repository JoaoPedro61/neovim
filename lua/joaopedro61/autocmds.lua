local settings = require("joaopedro61.settings")

local autocmd = vim.api.nvim_create_autocmd

-- Disable the concealing in some file formats
-- The default conceallevel is 3
autocmd("FileType", {
  pattern = { "json", "jsonc", "maskdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- Set colorcolumn
autocmd("FileType", {
  pattern = { "python", "rst", "rust", "c", "cpp", "typescript" },
  command = "set colorcolumn=80",
})

-- Set wrap to this files types
autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

autocmd("BufWritePre", {
  callback = function(event)
    if settings.is_enabled("auto_format", { bufnr = event.buf }) then
      require("joaopedro61.plugins.util.format")()
    end
  end,
})

autocmd({ "FileType", "LspAttach" }, {
  callback = function(event)
    settings.apply_buffer(event.buf)
  end,
})

autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function(event)
    if settings.is_enabled("lsp.diagnostics", { bufnr = event.buf }) and vim.diagnostic.is_enabled({ bufnr = event.buf }) then
      for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).zindex then
          return
        end
      end
      vim.diagnostic.open_float({
        scope = "cursor",
        focusable = false,
        close_events = {
          "CursorMoved",
          "CursorMovedI",
          "BufHidden",
          "InsertCharPre",
          "WinLeave",
        },
      })
    end
  end,
})
