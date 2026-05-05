local M = {}

M.disabled_builtin = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

--- Disables bundled Vim/Neovim plugins listed in `disabled_builtin`.
function M.disable_builtin()
  for _, plugin in ipairs(M.disabled_builtin) do
    vim.g["loaded_" .. plugin] = 1
  end
end

setmetatable(M, {
  --- @param module table
  __call = function(module, ...)
    module.disable_builtin(...)
  end,
})

return M
