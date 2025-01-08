local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local nomap = vim.keymap.del
local on_attach_with_keybinds = function(client, bufnr)
    on_attach(client, bufnr)
    local keymaps_list = vim.api.nvim_get_keymap('n')
    local mappings_table = {}
      for _, mapping in ipairs(keymaps_list) do
        mappings_table[mapping.lhs] = mapping
      end
    if mappings_table['gr'] then
        nomap("n", "gr", { buffer = bufnr })
    end
    if mappings_table['gd'] then
        nomap("n", "gd", { buffer = bufnr })
    end
    if mappings_table['gi'] then
        nomap("n", "gi", { buffer = bufnr })
    end
end

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "clangd", "tailwindcss", "volar", "lua_ls", "svelte", "yamlls", "astro", "nil_ls",
    "jsonls", "wgsl_analyzer", "bashls", "gdscript", "eslint", "tsserver", "zls", "cmake", "gopls" }

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
    omnisharp = function (config)
        return vim.tbl_deep_extend("force", config, {
            cmd = { "omnisharp" }
        })
    end,
    gopls = function (config)
        return vim.tbl_deep_extend("force", config, {
            settings = {
                gopls = {
                    completeUnimported = true,
                    usePlaceholders = true,
                    analyses = {
                        unusedparams = true,
                    },
                }
            }
        })
    end
}

for _, lsp in ipairs(servers) do
    print("Configuring LSP " .. lsp)
    local config = {
        on_init = on_init,
        on_attach = on_attach_with_keybinds,
        capabilities = capabilities,
    }
    -- Extra per-lsp config
    if config_extras[lsp] then
        config = config_extras[lsp](config)
    end

    lspconfig[lsp].setup(config)
end

-- Setup swift lsp
 local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
 vim.api.nvim_create_autocmd("FileType", {
 	pattern = { "swift" },
 	callback = function()
 		local root_dir = vim.fs.dirname(vim.fs.find({
 			"Package.swift",
 			".git",
 		}, { upward = true })[1])
 		local client = vim.lsp.start({
 			name = "sourcekit-lsp",
 			cmd = { "sourcekit-lsp" },
 			root_dir = root_dir,
 		})
 		vim.lsp.buf_attach_client(0, client)
 	end,
 	group = swift_lsp,
 })
