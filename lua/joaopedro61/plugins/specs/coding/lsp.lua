local lsp = require("joaopedro61.plugins.util.lsp")
local settings = require("joaopedro61.settings")

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      keys = {
        {
          "gd",
          vim.lsp.buf.definition,
          desc = "Goto Definition",
          has = "definition",
        },
        {
          "gr",
          vim.lsp.buf.references,
          desc = "References",
          nowait = true,
        },
        { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
        { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        {
          "<C-k>",
          function()
            return vim.lsp.buf.signature_help()
          end,
          mode = { "i", "n" },
          desc = "Signature Help",
          has = "signatureHelp",
        },
        {
          "<leader>ca",
          vim.lsp.buf.code_action,
          desc = "Code Action",
          mode = { "n", "v" },
          has = "codeAction",
        },
        {
          "<leader>cA",
          lsp.action.source,
          desc = "Source Action",
          has = "codeAction",
        },

        -- Inlay actions that no need selection
        { "<leader>cL", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        {
          "K",
          function()
            return vim.lsp.buf.hover()
          end,
          desc = "Hover",
        },
        {
          "<leader>cl",
          vim.lsp.codelens.run,
          desc = "Run Codelens",
          mode = { "n", "v" },
          has = "codeLens",
        },
        {
          "<leader>cC",
          vim.lsp.codelens.refresh,
          desc = "Refresh & Display Codelens",
          mode = { "n" },
          has = "codeLens",
        },
        {
          "<leader>cR",
          function()
            Snacks.rename.rename_file()
          end,
          desc = "Rename File",
          mode = { "n" },
          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
        },
        {
          "<leader>cr",
          vim.lsp.buf.rename,
          desc = "Rename",
          has = "rename",
        },
        {
          "]]",
          function()
            Snacks.words.jump(vim.v.count1)
          end,
          has = "documentHighlight",
          desc = "Next Reference",
          cond = function()
            return Snacks.words.is_enabled()
          end,
        },
        {
          "[[",
          function()
            Snacks.words.jump(-vim.v.count1)
          end,
          has = "documentHighlight",
          desc = "Prev Reference",
          cond = function()
            return Snacks.words.is_enabled()
          end,
        },
      },
    },
    config = function(_, opts)
      lsp.setup()

      if vim.lsp.inlay_hint then
        lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
          if settings.is_enabled("lsp.inlay_hint", { bufnr = buffer }) and lsp.is_valid_buf(buffer) then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      if vim.lsp.codelens then
        lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
          if settings.is_enabled("lsp.codelens", { bufnr = buffer }) and lsp.is_valid_buf(buffer) then
            local group = vim.api.nvim_create_augroup("nvim-lsp-codelens-" .. buffer, { clear = true })

            vim.api.nvim_create_autocmd({
              "BufEnter",
              "InsertLeave",
            }, {
              group = group,
              buffer = buffer,
              callback = function()
                vim.lsp.codelens.refresh({ bufnr = buffer })
              end,
            })
          end
        end)
      end

      local servers = opts.servers or {}
      local setups = opts.setups or {}
      local capabilities = lsp.get_default_capabilities(opts.capabilities)
      local servers_installer = lsp.servers.get_servers_to_install(servers)
      local multi_instance_control = {} --- @type string[]

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if setups[server] then
          if setups[server](server, server_opts) then
            return
          end
        elseif setups["*"] then
          if setups["*"](server, server_opts) then
            return
          end
        end
        if not vim.tbl_contains(multi_instance_control, server) then
          multi_instance_control[#multi_instance_control + 1] = server
          -- This fixies the migration of lspconfig to vim.lsp.config
          -- The mason-lspconfig will still use lspconfig to setup the servers
          vim.lsp.config(server, server_opts)
        end
      end

      if servers_installer.mason then
        lsp.servers.install_mason_servers(servers_installer.mason, setup)
      end

      if servers_installer.custom then
        for _, server_name in ipairs(servers_installer.custom) do
          setup(server_name)
        end
      end
    end,
  },
}
