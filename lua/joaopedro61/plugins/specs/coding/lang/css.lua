return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "scss",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "prettier" })
        end,
      },
    },
    opts = {
      formatters_by_ft = {
        css = {
          "prettier",
        },
        scss = {
          "prettier",
        },
        less = {
          "prettier",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        css_variables = {},
        cssmodules_ls = {},
      },
    },
  },
}
