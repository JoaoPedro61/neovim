return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {},
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local registry = require("mason-registry")
      registry.refresh(function()
        local seen = {}
        for _, tool in ipairs(opts.ensure_installed) do
          if not seen[tool] then
            seen[tool] = true
            local package = registry.get_package(tool)
            if not package:is_installed() then
              package:install()
            end
          end
        end
      end)
    end,
  },
}
