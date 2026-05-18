local terminal_navigation = {
  { "<C-h>", "h" },
  { "<C-Left>", "h" },
  { "<C-j>", "j" },
  { "<C-Down>", "j" },
  { "<C-k>", "k" },
  { "<C-Up>", "k" },
  { "<C-l>", "l" },
  { "<C-Right>", "l" },
}

local function set_terminal_keymaps(event)
  local opts = { buffer = event.buf, silent = true }

  for _, mapping in ipairs(terminal_navigation) do
    local lhs, direction = mapping[1], mapping[2]

    vim.keymap.set("t", lhs, "<Cmd>wincmd " .. direction .. "<CR>", opts)
  end
end

return {
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>\\", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    version = "*",
    opts = {
      direction = "horizontal",
    },
    init = function()
      local group = vim.api.nvim_create_augroup("joaopedro61_terminal_keymaps", { clear = true })

      vim.api.nvim_create_autocmd("TermOpen", {
        group = group,
        pattern = "term://*",
        callback = set_terminal_keymaps,
      })
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
