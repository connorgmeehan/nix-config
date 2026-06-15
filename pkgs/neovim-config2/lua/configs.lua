local opt = vim.opt
opt.guicursor = "i:ver25" -- Use thin caret cursor in insert mode
opt.colorcolumn = "80" -- Highlight column 80
opt.signcolumn = "yes:1" -- Always show sign column
opt.termguicolors = true -- Enable true colors
opt.ignorecase = true -- Ignore case in search
opt.swapfile = false -- Disable swap files
opt.autoindent = true -- Enable auto indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 4 -- Number of spaces for a tab
opt.softtabstop = 4 -- Number of spaces for a tab when editing
opt.shiftwidth = 4 -- Number of spaces for autoindent
opt.shiftround = true -- Round indent to multiple of shiftwidth
opt.listchars = "tab: ,multispace:|" -- Characters to show for tabs, spaces, and end of line
opt.fillchars = "eob: " -- Replaces ~
opt.list = true -- Show whitespace characters
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.numberwidth = 2 -- Width of the line number column
opt.wrap = false -- Disable line wrapping
opt.cursorline = true -- Highlight the current line
opt.scrolloff = 8 -- Keep 8 lines above and below the cursor
opt.inccommand = "nosplit" -- Shows the effects of a command incrementally in the buffer
opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Directory for undo files
opt.undofile = true -- Enable persistent undo
opt.completeopt = { "menuone", "popup", "noinsert" } -- Options for completion menu
opt.winborder = "single" -- Use rounded borders for windows
opt.hlsearch = true -- Disable highlighting of search results
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.laststatus = 3 -- Global status line

vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "󱈸",
			[vim.diagnostic.severity.INFO] = "󰙎",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "WinBar", { link = "SpecialComment" })
	end,
})

vim.lsp.enable("ts_ls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("gopls")
vim.lsp.enable("cmake")
vim.lsp.enable("lua_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("yamlls")
vim.lsp.enable("nil_ls")
