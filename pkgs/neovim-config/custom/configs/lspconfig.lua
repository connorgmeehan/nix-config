local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local map = vim.keymap.set
local nomap = vim.keymap.del
local on_attach_with_keybinds = function(client, bufnr)
    on_attach(client, bufnr)
    vim.schedule(function()
        nomap("n", "gr", { buffer = bufnr })
        nomap("n", "gd", { buffer = bufnr })
        nomap("n", "gi", { buffer = bufnr })
        map("n", "gI", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "[LSP] Incoming calls", buffer = bufnr })
        map("n", "<leader>cI", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "[LSP] Incoming calls", buffer = bufnr })

        map("n", "gO", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "[LSP] Outgoing calls", buffer = bufnr })
        map("n", "<leader>cO", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "[LSP] Outgoing calls", buffer = bufnr })

        map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "[LSP] Definitions", buffer = bufnr })
        map("n", "<leader>cd", "<cmd>Telescope lsp_definitions<CR>", { desc = "[LSP] Definitions", buffer = bufnr })

        map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "[LSP] References", buffer = bufnr })
        map("n", "<leader>cr", "<cmd>Telescope lsp_references<CR>", { desc = "[LSP] References", buffer = bufnr })

        map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "[LSP] Implementation", buffer = bufnr })
        map("n", "<leader>ci", "<cmd>Telescope lsp_implementations<CR>", { desc = "[LSP] Implementation", buffer = bufnr })

        map("n", "gh", "<cmd>Telescope lsp_implementations<CR>", { desc = "[LSP] Implementation", buffer = bufnr })
        map("n", "<leader>ch", "<cmd>Telescope lsp_implementations<CR>", { desc = "[LSP] Implementation", buffer = bufnr })

        map("n", "gh", vim.lsp.buf.signature_help, { desc = "[LSP] Type Def", buffer = bufnr })
        map("n", "<leader>ch", vim.lsp.buf.signature_help, { desc = "[LSP] Type Def", buffer = bufnr })

        map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "[LSP] Type Def", buffer = bufnr })
        map("n", "<leader>ct", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "[LSP] Type Def", buffer = bufnr })


        map("n", "<leader>cf", vim.lsp.buf.format, { desc = "[LSP] Format buffer", buffer = bufnr })
        map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[LSP] Code actions", buffer = bufnr })
        map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[LSP] Rename", buffer = bufnr })
        map("n", "<leader>cg", function() require("neogen").generate({}) end, { desc = "Generate docs", buffer = bufnr })
        map("n", "<C-n>", vim.diagnostic.goto_next, { desc = "Next diagnostic", buffer = bufnr })
        map("n", "<C-p>", vim.diagnostic.goto_prev, { desc = "Next diagnostic", buffer = bufnr })
        map("n", "<S-k>", vim.lsp.buf.hover, { desc = "Show hover doc", buffer = bufnr })
    end)
end

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "clangd", "tailwindcss", "volar", "lua_ls", "svelte", "yamlls", "astro", "nil_ls",
    "jsonls", "wgsl_analyzer", "bashls", "gdscript", "eslint", "tsserver", "zls", "cmake" }

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
