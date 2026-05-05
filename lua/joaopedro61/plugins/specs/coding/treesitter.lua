return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {},
      auto_install = true,
      autopairs = { enable = true },
      indent = { enable = true },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      },
      rainbow = {
        enable = true,
        extended_mode = false,
        max_file_lines = nil,
      },
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
