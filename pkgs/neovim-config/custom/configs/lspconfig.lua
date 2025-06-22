require("nvchad.configs.lspconfig").defaults()

local configs = {
    html = { enabled = true },
    cssls = { enabled = true },
    eslint = { enabled = true },
    clangd = { enabled = true },
    tailwindcss = { enabled = true },
    vue_ls = { enabled = true },
    lua_ls = { enabled = true },
    svelte = { enabled = true },
    yamlls = { enabled = true },
    astro = { enabled = true },
    nil_ls = { enabled = true },
    jsonls = { enabled = true },
    wgsl_analyzer = { enabled = true },
    bashls = { enabled = true },
    gdscript = { enabled = true },
    zls = { enabled = true },
    cmake = { enabled = true },
    gopls = { enabled = true },
    omnisharp = { enabled = true },
    gleam = { enabled = true },
    biome = { enabled = true },
}

-- Delay enabling LSPs until after the configuration is loaded
vim.schedule(function()
    for lsp_key, item in pairs(configs) do
        if item.enabled then
            vim.lsp.enable(lsp_key)
        end
    end
end)

return configs
