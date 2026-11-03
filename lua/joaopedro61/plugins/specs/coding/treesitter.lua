return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/treesitter",
      ensure_installed = {},
      auto_install = true,
      indent = true,
      highlight = true,
    },
    config = function(_, opts)
      local treesitter = require("nvim-treesitter")

      treesitter.setup({ install_dir = opts.install_dir })
      treesitter.install(opts.ensure_installed)

      local function enable(buf, lang)
        if opts.highlight then
          vim.treesitter.start(buf, lang)
        end
        if opts.indent then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("joaopedro61_treesitter", { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if not lang then
            return
          end

          if vim.treesitter.language.add(lang) then
            enable(event.buf, lang)
            return
          end

          if not opts.auto_install or not vim.list_contains(treesitter.get_available(), lang) then
            return
          end

          treesitter.install({ lang }):await(function(err, installed)
            if err or not installed then
              return
            end
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(event.buf) and vim.treesitter.language.add(lang) then
                enable(event.buf, lang)
              end
            end)
          end)
        end,
      })
    end,
  },
}
