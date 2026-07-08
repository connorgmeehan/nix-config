local s = { silent = true }
local keymap = vim.keymap.set

vim.g.mapleader = " "

keymap("n", "<space>", "<Nop>")
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", s)

keymap("n", "<leader>-", "<cmd>split<CR>", s) -- Split the window horizontally
keymap("n", "<leader>\\", "<cmd>vsplit<CR>", s) -- Split the window horizontally
keymap("n", "<leader>q", "<cmd>q<CR>", s) -- Quit Neovim
keymap("n", "<leader>s", "<cmd>w<CR>", s) -- Save
keymap("n", "<leader>x", "<cmd>bdel<CR>", s) -- Close buffer

keymap("n", "<C-n>", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
keymap("n", "<C-p>", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })

-- LSP
keymap("n", "gd", vim.lsp.buf.definition, { desc = "[LSP] Definition" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "[LSP] References" })
keymap("n", "gi", vim.lsp.buf.implementation, { desc = "[LSP] Implementation" })
keymap("n", "gt", vim.lsp.buf.type_definition, { desc = "[LSP] Type definition" })
keymap("n", "gh", vim.lsp.buf.signature_help, { desc = "[LSP] Signature help" })
keymap("n", "gO", vim.lsp.buf.outgoing_calls, { desc = "[LSP] Outgoing calls" })
keymap("n", "gI", vim.lsp.buf.incoming_calls, { desc = "[LSP] Incoming calls" })
keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[LSP] Rename" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[LSP] Code actions" })

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")
