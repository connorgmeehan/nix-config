require("nvchad.mappings")

local map = vim.keymap.set

---@type MappingsTable

map("n", "<leader>s", "<CMD>w<CR>", { desc = "Save file" })
map("n", "<leader>-", "<CMD>split<CR>", { desc = "Hori Split" })
map("n", "<leader>\\", "<CMD>vsplit<CR>", { desc = "Vert Split" })
map("n", "<leader>q", "<CMD>q<CR>", { desc = "Quit buffer" })
map("n", "<leader>,", "<cmd>Telescope buffers<cr>", { desc = "Quit buffer" })

-- Tree
map("n", "<leader>e", "<cmd>:Neotree filesystem reveal left toggle<CR>", { desc = "File tree" })
map("n", "<leader>E", "<cmd>:Neotree filesystem reveal left<CR>", { desc = "Focus tree" })

map("n", "<leader>fp", "<cmd>:Telescope resume<CR>", { desc = "Previous Telescope" })

-- LSP
-- Keybinds now set in [lspconfig config](./configs/lspconfig.lua) due to 
-- https://github.com/NvChad/NvChad/issues/2854

-- Git signs
map("n", "<leader>gR", "<cmd>lua require'gitsigns'.reset_hunk()<CR>", { desc = "Reset Hunk" })
map("n", "<leader>gn", "<cmd>lua require'gitsigns'.next_hunk()<CR>", { desc = "Next Hunk" })
map("n", "<leader>gp", "<cmd>lua require'gitsigns'.prev_hunk()<CR>", { desc = "Prev Hunk" })
-- Tree
-- ["<leader>E"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
-- ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
-- Debugging
map("n", "<leader>db", "<CMD> DapToggleBreakpoint <CR>", { desc = "Toggle Breakpoint" })
map("n", "<leader>dn", "<CMD> DapStepOver <CR>", { desc = "Step Over" })
map("n", "<leader>ds", function() require("dapui").open() end, {desc = "Open Debug UI"})
map("n", "<leader>dq", function()
    local session = require("dap").session()
    if session then
      require("dap").disconnect(nil, function ()
        require("dapui").close()
      end)();
    else
      require("dapui").close()
    end
  end,
  { desc = "Open Debug UI" }
)
map("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>", { desc = "Continue" })
map("n", "<leader>dr", "<cmd>lua require('dap').run_to_cursor()<CR>", { desc = "Run to cursor" })
map("n", "<leader>du", "<cmd>lua require('dap').up()<CR>", { desc = "Up Stack" })
map("n", "<leader>dd", "<cmd>lua require('dap').down()<CR>", { desc = "Down Stack" })
map("n", "<leader>di", "<cmd>lua require('dap').step_in()<CR>", { desc = "Step in" })
map("n", "<leader>do", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step out" })
