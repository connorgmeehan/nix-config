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

-- Telescope
map("n", "<leader>fp", "<cmd>:Telescope resume<CR>", { desc = "Previous Telescope" })
map("n", "<leader>fg", "<cmd>:Telescope git_bcommits<CR>", { desc = "Git file history " })

-- LSP
map("n", "gI", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "[LSP] Incoming calls" })
map("n", "<leader>cI", "<cmd>Telescope lsp_incoming_calls<CR>", { desc = "[LSP] Incoming calls" })

map("n", "gO", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "[LSP] Outgoing calls" })
map("n", "<leader>cO", "<cmd>Telescope lsp_outgoing_calls<CR>", { desc = "[LSP] Outgoing calls" })

map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "[LSP] Definitions" })
map("n", "<leader>cd", "<cmd>Telescope lsp_definitions<CR>", { desc = "[LSP] Definitions" })

map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "[LSP] References" })
map("n", "<leader>cr", "<cmd>Telescope lsp_references<CR>", { desc = "[LSP] References" })

map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "[LSP] Implementation" })
map("n", "<leader>ci", "<cmd>Telescope lsp_implementations<CR>", { desc = "[LSP] Implementation" })

map("n", "gh", "<cmd>Telescope lsp_implementations<CR>", { desc = "[LSP] Implementation" })
map("n", "<leader>ch", "<cmd>Telescope lsp_implementations<CR>", { desc = "[LSP] Implementation" })

map("n", "gh", vim.lsp.buf.signature_help, { desc = "[LSP] Type Def" })
map("n", "<leader>ch", vim.lsp.buf.signature_help, { desc = "[LSP] Type Def" })

map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "[LSP] Type Def" })
map("n", "<leader>ct", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "[LSP] Type Def" })


map("n", "<leader>cf", function ()
    vim.lsp.buf.format({
        filter = function (client)
            local lsp_config = require("configs.lspconfig")
            local settings = lsp_config[client.name]
            print("LSP client name: " .. client.name)
            if settings.format ~= nil then
                print("\t".. settings.format and "true" or "false")
                return settings.format
            end
            print("\t falling back to default: true")
            return true
        end
    })
end, { desc = "[LSP] Format buffer" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[LSP] Code actions" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[LSP] Rename" })
map("n", "<leader>cg", function() require("neogen").generate({}) end, { desc = "Generate docs" })
map("n", "<C-n>", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<C-p>", vim.diagnostic.goto_prev, { desc = "Next diagnostic" })
map("n", "<S-k>", vim.lsp.buf.hover, { desc = "Show hover doc" })

-- Git signs
map("n", "<leader>gR", "<cmd>lua require'gitsigns'.reset_hunk()<CR>", { desc = "Reset Hunk" })
map("n", "<leader>gh", "<cmd>:Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
map("n", "<leader>gn", "<cmd>lua require'gitsigns'.next_hunk()<CR>", { desc = "Next Hunk" })
map("n", "<leader>gp", "<cmd>lua require'gitsigns'.prev_hunk()<CR>", { desc = "Prev Hunk" })
map("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "Blame" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
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
