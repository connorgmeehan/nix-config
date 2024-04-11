---@type MappingsTable
local M = {}
--
-- M.groups = {
--   n = {
--     ["<leader>"] = {
--       c = { name = "code" },
--       d = { name = "dap" },
--       f = { name = "files" },
--       g = { name = "git" },
--       l = { name = "live server" },
--       p = { name = "terms" },
--       r = { name = "refactor" },
--       t = { name = "telescope" },
--       w = { name = "which-key/workspace" },
--     },
--   },
--   v = {
--     ["<leader>"] = {
--       r = { name = "refactor" },
--       t = { name = "markdown tables" },
--     }
--   }
-- }
M.disabled = {
  ["<C-n>"] = "",
  ["<leader>e"] = "",
}

M.general = {
  n = {
    -- Core
    ["<leader>s"] = { "<CMD>w<CR>", "Save file", opts = { nowait = true } },
    ["<leader>-"] = { "<CMD>split<CR>", "Hori Split", opts = { nowait = true } },
    ["<leader>\\"] = { "<CMD>vsplit<CR>", "Vert Split", opts = { nowait = true } },
    ["<leader>q"] = { "<CMD>q<CR>", "Quit buffer", opts = { nowait = true } },
    -- LSP
    ["gd"] = { "<cmd>Telescope lsp_definitions<CR>", "Go definitions" },
    ["gt"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Go type defs" },
    ["gr"] = { "<cmd>Telescope lsp_references<CR>", "Go references" },
    ["gs"] = { "<cmd>Telescope lsp_document_symbols<CR>", "Go doc symbols" },
    ["gS"] = { "<cmd>Telescope lsp_workspace_symbols<CR>", "Go workspace symbols" },

    -- Tree
    ["<leader>e"] = { "<cmd>:Neotree filesystem reveal left toggle<CR>", "File tree"},
    ["<leader>E"] = { "<cmd>:Neotree filesystem reveal left<CR>", "Focus tree"},

    ["<leader>fp"] = { "<cmd>:Telescope resume<CR>", "Previous Telescope"},

    --
    ["<leader>cd"] = { "<cmd>Telescope lsp_definitions<CR>", "Format buffer" },
    ["<leader>ct"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Go typedef" },
    ["<leader>cf"] = { vim.lsp.buf.format, "Format buffer" },
    ["<leader>ca"] = { vim.lsp.buf.code_action, "Code actions" },
    ["<leader>cr"] = { vim.lsp.buf.rename, "Rename" },
    ["<leader>cg"] = {
      function()
        require("neogen").generate({})
      end,
      "Generate docs",
    },
    ["<C-n>"] = { vim.diagnostic.goto_next, "Next diagnostic" },
    ["<C-p>"] = { vim.diagnostic.goto_prev, "Next diagnostic" },
    ["<S-k>"] = { vim.lsp.buf.hover, "Show hover doc" },
    -- Git signs
    ["<leader>gR"] = { "<cmd>lua require'gitsigns'.reset_hunk()<CR>", "Reset Hunk" },
    ["<leader>gn"] = { "<cmd>lua require'gitsigns'.next_hunk()<CR>", "Next Hunk" },
    ["<leader>gp"] = { "<cmd>lua require'gitsigns'.prev_hunk()<CR>", "Prev Hunk" },
    -- Tree
    -- ["<leader>E"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
    -- ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
    -- Debugging
    ["<leader>db"] = { "<CMD> DapToggleBreakpoint <CR>", "Toggle Breakpoint" },
    ["<leader>dn"] = { "<CMD> DapStepOver <CR>", "Step Over" },
    ["<leader>ds"] = {
      function()
        require("dapui").open()
      end,
      "Open Debug UI",
    },
    ["<leader>dq"] = {
      function()
        local session = require("dap").session()
        if session then
          require("dap").disconnect(nil, function ()
            require("dapui").close()
          end)();
        else
          require("dapui").close()
        end
      end,
      "Open Debug UI",
    },
    ["<leader>dc"] = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
    ["<leader>dr"] = { "<cmd>lua require('dap').run_to_cursor()<CR>", "Run to cursor" },
    ["<leader>du"] = { "<cmd>lua require('dap').up()<CR>", "Up Stack" },
    ["<leader>dd"] = { "<cmd>lua require('dap').down()<CR>", "Down Stack" },
    ["<leader>di"] = { "<cmd>lua require('dap').step_in()<CR>", "Step in" },
    ["<leader>do"] = { "<cmd>lua require('dap').step_out()<CR>", "Step out" },
  },
}

-- more keybinds!

return M
