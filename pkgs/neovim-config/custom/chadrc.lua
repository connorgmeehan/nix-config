---@type ChadrcConfig
local M = {}

M.lsp = { signature = true }

-- Path to overriding theme and highlights files
M.base64 = {
    theme = "kanagawa",
    transparency = true,
    theme_toggle = { "kanagawa", "one_light" },
    hl_override = {
        Comment = {
            italic = true,
        },
    },
    hl_add = {
        NvimTreeOpenedFolderName = { fg = "green", bold = true },
    },
}

M.ui = {
    tabufline = {
        order = { "treeOffset", "buffers", "tabs", "btns", "abc" },
    },
    statusline = {
        theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
        -- default/round/block/arrow separators work only for default statusline theme
        -- round and block will work for minimal theme only
        separator_style = "round",
        order = nil,
        modules = nil,
    },
    cmp = {
        lspkind_text = false,
        style = "flat_dark",
    }
}

-- check core.mappings for table structure
return M
