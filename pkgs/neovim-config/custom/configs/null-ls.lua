local present, null_ls = pcall(require, "null-ls")

if not present then
    return
end

-- Helper to conditionally register eslint handlers only if eslint is
-- config. If eslint is not configured for a project, it just fails.
local function has_eslint_config(utils)
    return utils.root_has_file({
        ".eslintrc",
        ".eslintrc.cjs",
        ".eslintrc.js",
        ".eslintrc.json",
        "eslint.config.cjs",
        "eslint.config.js",
        "eslint.config.mjs",
    })
end

local b = null_ls.builtins

local sources = {
    -- webdev stuff
    -- b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
    -- b.formatting.rustywind, -- Disabled for work
    b.formatting.prettierd,
    require("none-ls.diagnostics.eslint").with({
        condition = has_eslint_config,
    }),
    require("none-ls.code_actions.eslint").with({
        condition = has_eslint_config,
    }),

    -- Lua
    b.formatting.stylua,

    -- cpp
    b.formatting.clang_format,
}

null_ls.setup {
    sources = sources,
}
