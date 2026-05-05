return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "folke/snacks.nvim",
    },
    version = "*",
    opts = {
      options = {
        themable = true,
        color_icons = true,
        numbers = "both",
        diagnostics = "nvim_lsp",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        indicator = {
          style = "none",
        },
        offsets = {
          {
            filetype = "NvimTree",
            text = " Explorer",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer/tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer/tab" },
    },
    config = function(_, opts)
      local ok, snacks = pcall(require, "snacks")
      if ok and snacks.bufdelete then
        local close_command = function(bufnr)
          snacks.bufdelete(bufnr)
        end

        opts.options.close_command = close_command
        opts.options.right_mouse_command = close_command
      end

      require("bufferline").setup(opts)

      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(vim.cmd, "BufferLineRefresh")
          end)
        end,
      })
    end,
  },
}
