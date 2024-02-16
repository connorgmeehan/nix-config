local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ccls", "tailwindcss", "volar", "lua_ls", "svelte", "yamlls", "astro", "nil_ls", "jsonls", "wgsl_analyzer", "bashls" }

local config_extras = {
  volar = function(config)
    config.init_options = {
      typescript = {
        sdk = "",
      },
    }
    return config
  end,
  lua_ls = function(config)
    require("neodev").setup()
    return vim.tbl_deep_extend("force", config, {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })
  end,
}

for _, lsp in ipairs(servers) do

  print("Configuring LSP " .. lsp)
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
  -- Extra per-lsp config
  if config_extras[lsp] then
    config = config_extras[lsp](config)
  end

  lspconfig[lsp].setup(config)
end
