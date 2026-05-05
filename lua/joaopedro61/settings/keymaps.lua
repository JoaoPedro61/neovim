local settings = require("joaopedro61.settings")
local merge = require("joaopedro61.util.merge")

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>Sl", function()
  settings.load()
  settings.apply()
end, merge(opts, { desc = "Load and apply user settings" }))

map("n", "<leader>So", ":SettingsOpen<CR>", merge(opts, { desc = "Open user settings" }))
map("n", "<leader>Sw", ":SettingsCreateWorkspace<CR>", merge(opts, { desc = "Create neovim workspace settings" }))
