local settings = require("joaopedro61.settings")

local themes = {
  {
    name = "Default Dark",
    colorscheme = "default",
    settings = { name = "default", variant = "dark" },
  },
  {
    name = "Default Light",
    colorscheme = "default",
    settings = { name = "default", variant = "light" },
    before = [[
      vim.opt.background = "light"
    ]],
  },
  {
    name = "Tokyonight Day",
    colorscheme = "tokyonight-day",
    settings = { name = "tokyonight", variant = "day" },
    before = [[
      vim.opt.background = "light"
    ]],
  },
  {
    name = "Tokyonight Night",
    colorscheme = "tokyonight-night",
    settings = { name = "tokyonight", variant = "night" },
  },
  {
    name = "Lavi",
    colorscheme = "lavi",
    settings = { name = "lavi" },
  },
  {
    name = "Yorumi",
    colorscheme = "yorumi",
    settings = { name = "yorumi" },
  },
  {
    name = "Sonokai",
    colorscheme = "sonokai",
    settings = { name = "sonokai", variant = "andromeda" },
    before = [[
      vim.g.sonokai_style = "andromeda"
    ]],
  },
  {
    name = "Sonokai (transparent)",
    colorscheme = "sonokai",
    settings = { name = "sonokai", variant = "transparent" },
    before = [[
      vim.g.sonokai_transparent_background = "1"
      vim.g.sonokai_style = "andromeda"
      vim.cmd('TransparentEnable')
    ]],
  },
}

--- Resolves the Themery theme name from `settings.colorscheme`.
---
--- @return string name Themery theme name.
local function get_default_theme()
  local colorscheme = settings.safe_get("colorscheme.name", "sonokai")
  local variant = settings.safe_get("colorscheme.variant", "transparent")

  for _, theme in ipairs(themes) do
    local theme_settings = theme.settings or {}
    local name_matches = theme_settings.name == colorscheme or theme.colorscheme == colorscheme
    local variant_matches = theme_settings.variant == nil or theme_settings.variant == variant

    if name_matches and variant_matches then
      return theme.name
    end
  end

  for _, theme in ipairs(themes) do
    if theme.settings and theme.settings.name == colorscheme then
      return theme.name
    end
  end

  return "Sonokai (transparent)"
end

return {
  {
    "zaldih/themery.nvim",
    priority = 1000,
    dependencies = {
      "folke/tokyonight.nvim",
      "yorumicolors/yorumi.nvim",
      "sainnhe/sonokai",
      {
        "b0o/lavi.nvim",
        dependencies = { "rktjmp/lush.nvim" },
      },
      {
        "xiyaowong/transparent.nvim",
        config = function()
          require("transparent").setup({
            -- Use the telescope highlights, to find panels highlights
            extra_groups = {
              -- Native Float Popups Panels
              "NormalFloat",
              "VertSplit",
              "Pmenu",
              "FloatBorder",

              -- NvimTree Plugin Panels
              "NvimTreeWinSeparator",
              "NvimTreeNormal",
              "NvimTreeNormalNC",

              -- Telescope Plugin Panels
              "TelescopeNormal",
              "TelescopeBorder",
              "TelescopePromptTitle",
              "TelescopePromptBorder",

              -- WhichKey Plugin Panels
              "WhichKeyNormal",
              "WhichKeyTitle",

              -- Bufferline Plugin Panels
              "BufferLineOffsetSeparator",
            },
          })

          if pcall(require, "lualine") then
            require("transparent").clear_prefix("lualine")
          end

          if pcall(require, "bufferline") then
            require("transparent").clear_prefix("bufferLine")
          end
        end,
      },
    },
    config = function()
      local themery = require("themery")
      local default_theme = get_default_theme()

      themery.setup({
        globalBefore = [[
          vim.opt.background = "dark"
          vim.cmd('TransparentDisable')

          vim.g.sonokai_transparent_background = "0"
          vim.g.sonokai_enable_italic = "1"
        ]],
        themes = themes,
        livePreview = true,
      })

      local keymap = vim.keymap

      keymap.set("n", "<leader>ut", ":Themery<CR>", { desc = "Open theme picker" })

      pcall(themery.setThemeByName, default_theme, true)
    end,
  },
}
