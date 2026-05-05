local has = require("joaopedro61.util.has")
local has_lazygit = has("lazygit", true)

--- Opens LazyGit through Snacks when available.
local function open_lazygit()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.lazygit then
    snacks.lazygit()
    return
  end

  vim.notify("Snacks lazygit is not available", vim.log.levels.WARN, {
    title = "Git",
  })
end

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  has_lazygit and {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      {
        "<leader>gg",
        open_lazygit,
        desc = "LazyGit",
      },
    },
  } or {},
}
