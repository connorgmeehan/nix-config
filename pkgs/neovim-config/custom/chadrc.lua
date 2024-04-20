---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files

M.ui = {
  theme = "kanagawa",
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

-- check core.mappings for table structure
return M
