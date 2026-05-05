local json = require("joaopedro61.util.json")
local get = require("joaopedro61.util.deep_find")
local set = require("joaopedro61.util.deep_set")
local defaults = require("joaopedro61.settings.defaults")

--- @class joaopedro61.Settings.Opts.Keymaps
--- @field enable? boolean Enable or disable keymaps settings.
---
--- @class joaopedro61.Settings.Opts
--- @field keymaps? joaopedro61.Settings.Opts.Keymaps Keymaps settings.
--- @field watch? boolean Reload `settings.json` after saving it.
--- @field workspace? boolean Load `.neovim/settings.json` from the working directory.
--- @field commands? boolean Register settings user commands.

local M = {}

M.filename = "settings.json"
M.workspace_dirname = ".neovim"

--- User-editable settings file, similar to VSCode's `settings.json`.
M.path = vim.fs.joinpath(vim.fn.stdpath("config"), M.filename)

--- Previous settings location kept as a read fallback for existing installs.
M.legacy_path = vim.fs.joinpath(vim.fn.stdpath("state"), M.filename)

M.workspace_path = nil --- @type string?
M.global_data = vim.deepcopy(defaults) --- @type joaopedro61.Settings
M.workspace_data = {} --- @type joaopedro61.Settings
M.data = vim.deepcopy(defaults) --- @type joaopedro61.Settings
M._augroup = vim.api.nvim_create_augroup("Joaopedro61Settings", { clear = true })
M.watch_enabled = true
M.workspace_enabled = true

--- Returns the active libuv API table.
---
--- @return table uv Neovim libuv compatibility table.
local function uv()
  return vim.uv or vim.loop
end

--- Returns the settings path that should be read.
---
--- @return string path Existing config path, legacy path, or config path.
function M.get_read_path()
  if uv().fs_stat(M.path) then
    return M.path
  end

  if uv().fs_stat(M.legacy_path) then
    return M.legacy_path
  end

  return M.path
end

--- Finds the nearest `.neovim/settings.json` from the current working directory upwards.
---
--- @param start? string Directory used as the search starting point.
--- @return string? path Workspace settings path, when present.
function M.find_workspace_path(start)
  local root = start or vim.fn.getcwd()
  local candidate = vim.fs.joinpath(root, M.workspace_dirname, M.filename)
  if uv().fs_stat(candidate) then
    return candidate
  end

  for dir in vim.fs.parents(root) do
    candidate = vim.fs.joinpath(dir, M.workspace_dirname, M.filename)
    if uv().fs_stat(candidate) then
      return candidate
    end
  end

  return nil
end

--- Returns all settings files in precedence order.
---
--- @return string[] paths Global and workspace settings paths.
function M.get_read_paths()
  local paths = { M.get_read_path() }
  M.workspace_path = M.workspace_enabled and M.find_workspace_path() or nil

  if M.workspace_path then
    paths[#paths + 1] = M.workspace_path
  end

  return paths
end

--- Loads user settings and merges them over defaults.
---
--- Defaults remain immutable so reloading cannot accumulate stale keys.
--- Precedence order is: defaults < global settings < workspace settings.
--- @return joaopedro61.Settings data Loaded settings table.
function M.load()
  local global_settings = json.read(M.get_read_path()) or {}
  M.workspace_path = M.workspace_enabled and M.find_workspace_path() or nil
  M.workspace_data = M.workspace_path and json.read(M.workspace_path) or {}
  M.global_data = vim.tbl_deep_extend("force", {}, defaults, global_settings)
  M.data = vim.tbl_deep_extend("force", {}, M.global_data, M.workspace_data)

  return M.data
end

--- Saves the global settings to `settings.json`.
---
--- @return boolean ok `true` when the write succeeds.
function M.save()
  return json.write(M.path, M.global_data)
end

--- Returns the workspace settings path for a directory.
---
--- @param root? string Workspace root. Defaults to the current working directory.
--- @return string path Workspace settings file path.
function M.get_workspace_path(root)
  return vim.fs.joinpath(root or vim.fn.getcwd(), M.workspace_dirname, M.filename)
end

--- Creates `.neovim/settings.json` from the effective current settings.
---
--- @param opts? { root?: string, force?: boolean, open?: boolean } Creation options.
--- @return string? path Created file path, or `nil` on failure.
function M.create_workspace_settings(opts)
  opts = opts or {}

  local root = opts.root or vim.fn.getcwd()
  local settings_dir = vim.fs.dirname(M.get_workspace_path(root))
  local settings_path = M.get_workspace_path(root)
  local exists = uv().fs_stat(settings_path) ~= nil

  if exists and not opts.force then
    vim.notify("Workspace settings already exists: " .. settings_path, vim.log.levels.WARN, {
      title = "Settings",
    })

    return nil
  end

  vim.fn.mkdir(settings_dir, "p")

  if not json.write(settings_path, M.data) then
    vim.notify("Fail to create workspace settings: " .. settings_path, vim.log.levels.ERROR, {
      title = "Settings",
    })

    return nil
  end

  M.load()
  M.apply()

  if M.watch_enabled then
    M.watch()
  end

  if opts.open then
    pcall(vim.cmd.edit, vim.fn.fnameescape(settings_path))
  end

  vim.notify("Workspace settings created: " .. settings_path, vim.log.levels.INFO, {
    title = "Settings",
  })

  return settings_path
end

--- Applies settings that have immediate Neovim effects.
---
--- Plugin-specific consumers can keep using `safe_get()` for settings that
--- must be applied from their own setup hooks.
function M.apply()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    M.apply_buffer(buf)
  end

  local colorscheme = M.safe_get("colorscheme.name", nil)
  if type(colorscheme) == "string" and colorscheme ~= "" then
    pcall(vim.cmd.colorscheme, colorscheme)
  end
end

--- Applies buffer-scoped settings for a buffer.
---
--- @param bufnr? integer Buffer number. Defaults to the current buffer.
function M.apply_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  if vim.diagnostic and vim.diagnostic.enable then
    pcall(vim.diagnostic.enable, M.is_enabled("lsp.diagnostics", { bufnr = bufnr }), { bufnr = bufnr })
  end

  if vim.lsp and vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
    pcall(vim.lsp.inlay_hint.enable, M.is_enabled("lsp.inlay_hint", { bufnr = bufnr }), { bufnr = bufnr })
  end

  if vim.lsp and vim.lsp.codelens then
    if M.is_enabled("lsp.codelens", { bufnr = bufnr }) then
      pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
    else
      pcall(vim.lsp.codelens.clear, nil, bufnr)
    end
  end
end

--- Watches `settings.json` and reloads/applies it after writes.
function M.watch()
  vim.api.nvim_clear_autocmds({ group = M._augroup })

  local patterns = { vim.fs.normalize(M.path), "*/" .. M.workspace_dirname .. "/" .. M.filename }
  M.workspace_path = M.workspace_enabled and M.find_workspace_path() or nil

  if M.workspace_path then
    patterns[#patterns + 1] = vim.fs.normalize(M.workspace_path)
  end

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = M._augroup,
    pattern = patterns,
    callback = function()
      M.load()
      M.apply()
      vim.notify("Settings reloaded", vim.log.levels.INFO, { title = "Settings" })
    end,
  })

  vim.api.nvim_create_autocmd("DirChanged", {
    group = M._augroup,
    callback = function()
      M.load()
      M.apply()
      M.watch()
      vim.notify("Workspace settings reloaded", vim.log.levels.INFO, { title = "Settings" })
    end,
  })
end

--- Registers settings-related user commands.
function M.create_commands()
  pcall(vim.api.nvim_del_user_command, "SettingsCreateWorkspace")
  pcall(vim.api.nvim_del_user_command, "SettingsOpen")

  local create_workspace = function(command)
    M.create_workspace_settings({
      force = command.bang,
      open = true,
    })
  end

  vim.api.nvim_create_user_command("SettingsCreateWorkspace", create_workspace, {
    bang = true,
    desc = "Create .neovim/settings.json from the current effective settings",
  })

  vim.api.nvim_create_user_command("SettingsOpen", function()
    local path = M.workspace_path or M.path
    vim.cmd.edit(vim.fn.fnameescape(path))
  end, {
    desc = "Open workspace settings when present, otherwise global settings",
  })
end

--- Normalizes a filetype lookup from a string, buffer number, or options table.
---
--- @param source? string|integer|{ bufnr?: integer, filetype?: string } Filetype source.
--- @return string filetype Resolved filetype.
function M.get_filetype(source)
  if type(source) == "string" then
    return source
  end

  if type(source) == "number" then
    return vim.bo[source].filetype
  end

  if type(source) == "table" then
    if source.filetype then
      return source.filetype
    end

    if source.bufnr then
      return vim.bo[source.bufnr].filetype
    end
  end

  return vim.bo.filetype
end

--- Checks whether a filetype is enabled for a settings section with `enable` and `exclude`.
---
--- @param path string Dot-separated path to a settings section.
--- @param source? string|integer|{ bufnr?: integer, filetype?: string } Filetype source.
--- @return boolean enabled `true` when the section is enabled and filetype is not excluded.
function M.is_enabled(path, source)
  local enabled = M.safe_get(path .. ".enable", true)
  if not enabled then
    return false
  end

  local exclude = M.safe_get(path .. ".exclude", {})
  local filetype = M.get_filetype(source)

  return not vim.tbl_contains(exclude, filetype)
end

--- Safely retrieves a value from the loaded settings.
---
--- @param path string Dot-separated settings path, for example `auto_format.enable`.
--- @param or_value any Default value returned when the path is not found.
--- @return any value Setting value or `or_value`.
function M.safe_get(path, or_value)
  local value = get(M.data, path, or_value)
  if value == nil then
    return or_value
  end

  return value
end

--- Safely sets and saves a value in the loaded settings.
---
--- @param path string Dot-separated settings path.
--- @param value any Value to store.
--- @return boolean ok `true` when the value was stored and saved.
function M.safe_set(path, value)
  local ok = set(M.global_data, path, value, false)
  if type(ok) ~= "nil" then
    local saved = M.save()
    if saved then
      M.load()
      M.apply()
    end

    return saved
  end

  vim.notify("Fail to set user settings with path: " .. path, vim.log.levels.ERROR, {
    title = "Settings",
  })

  return false
end

local default_opts = {
  keymaps = {
    enable = true,
  },
  commands = true,
  watch = true,
  workspace = true,
} --- @type joaopedro61.Settings.Opts

--- Loads, applies, and optionally watches user settings.
---
--- @param opts? joaopedro61.Settings.Opts Setup options.
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", {}, default_opts, opts or {})

  M.workspace_enabled = opts.workspace
  M.watch_enabled = opts.watch

  M.load()
  M.apply()

  if opts.watch then
    M.watch()
  end

  if opts.commands then
    M.create_commands()
  end

  if opts.keymaps.enable then
    require("joaopedro61.settings.keymaps")
  end
end

return M
