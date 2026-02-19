---@type ChadrcConfig
local M = {}

M.lsp = { signature = true }

-- Path to overriding theme and highlights files
M.base46 = {
    theme = "kanagawa",
    transparency = true,
    theme_toggle = { "kanagawa", "one_light" },
    integrations = { "diffview" },
    hl_override = {
        Comment = {
            italic = true,
        },
        DiffAdd = { bg = { "black", "green", 15 }, fg="NONE" },
        DiffAdded = { bg = { "black", "green", 20 }, fg = "NONE", bold = true },
        DiffChange = { bg = { "black", "yellow", 15 }, fg = "NONE" },
        DiffText = { bg = { "black", "yellow", 20 }, fg = "NONE" },
        DiffDelete = { bg = { "black", "red", 15 }, fg = "NONE" },
        DiffRemoved = { bg = { "black", "red", 20 }, fg = "NONE", bold = true },

        DiffModified = { bg = { "black", "yellow", 20 }, fg = "NONE", bold = true },
    },
}

M.ui = {
    tabufline = {
        enabled = true,
        lazyload = true,
        order = { "treeOffset", "buffers", "tabs", "btns" },
        modules = nil,
        bufwidth = 21,
    },

    statusline = {
        theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
        -- default/round/block/arrow separators work only for default statusline theme
        -- round and block will work for minimal theme only
        separator_style = "round",
        order = nil,
        modules = nil,
    },
}

-- check core.mappings for table structure
return M
