-- Passed into setup function in `plugins/conform.lua`
return {
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        json = { "prettierd" },
        markdown = { "prettierd" },
        astro = { "biome", lsp_format = "fallback" },
        cpp = { "clang_format" },
    },
}
