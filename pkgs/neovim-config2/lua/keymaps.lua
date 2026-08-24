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
keymap("n", "<leader>cp", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if vim.tbl_isempty(clients) then
		vim.notify("No LSP clients attached to this buffer")
		return
	end
	for _, client in ipairs(clients) do
		vim.notify(vim.inspect({
			name = client.name,
			id = client.id,
			root_dir = client.config.root_dir,
			filetypes = client.config.filetypes,
		}))
	end
end, { desc = "[LSP] Log info to :messages" })

keymap("n", "<leader>cl", function()
	vim.cmd("tabnew " .. require("vim.lsp.log").get_filename())
end, { desc = "[LSP] Open LSP logs in buffer" })

keymap("n", "<leader>fy", function()
	local abs = vim.fn.expand("%:p")
	local root = vim.fs.root(0, ".git")
	local path = root and vim.fs.relpath(root, abs) or abs
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy file path (relative to git root)" })
keymap("n", "<leader>fY", function()
	local abs = vim.fn.expand("%:p")
	vim.fn.setreg("+", abs)
	vim.notify("Copied: " .. abs)
end, { desc = "Copy file path (absolute)" })

keymap("n", "<leader>fo", function()
	local dir = vim.fn.expand("%:p:h")
	vim.system({ "open", dir })
end, { desc = "Open containing folder in Finder" })

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")
