local merge = require("joaopedro61.util.merge")

return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      direction = "horizontal",
    },
    config = function(_, opts)
      local ok, terminal = pcall(require, "toggleterm");

      if ok then
        terminal.setup(
          merge(opts, {
          })
        )

        function _G.set_terminal_keymaps()
          local km_opts = { buffer = 0 }

          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], km_opts)
          vim.keymap.set('t', '<C-Left>', [[<Cmd>wincmd h<CR>]], km_opts)
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], km_opts)
          vim.keymap.set('t', '<C-Down>', [[<Cmd>wincmd j<CR>]], km_opts)
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], km_opts)
          vim.keymap.set('t', '<C-Up>', [[<Cmd>wincmd k<CR>]], km_opts)
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], km_opts)
          vim.keymap.set('t', '<C-Right>', [[<Cmd>wincmd l<CR>]], km_opts)
        end

        vim.keymap.set("n", "<leader>\\", "<cmd>ToggleTerm<CR>")
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
      end
    end
  }
}
