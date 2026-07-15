local icons = require("constants").icons
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
opt.splitbelow = true -- When :vsplit, move cursor below
opt.splitright = true -- when :split, move cursor right

vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

-- Indent guides, synced to editor config, autocommand adds mutlispace: based on option set
opt.listchars = "tab: "..icons.seperator_sm .." ,"
-- "multispace:|   " -- Characters to show for tabs, spaces, and end of line
vim.api.nvim_create_autocmd({ "BufEnter", "OptionSet" }, {
	callback = function(args)
		if args.event == "OptionSet" and args.match ~= "shiftwidth" then
			return
		end
		local sw = vim.bo.shiftwidth
		if sw > 1 then
			vim.opt_local.listchars:append({ leadmultispace = "|" .. string.rep(" ", sw - 1) })
		end
	end,
})

-- Configure diagnostic icons
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.error,
			[vim.diagnostic.severity.WARN] = icons.warn,
			[vim.diagnostic.severity.INFO] = icons.info,
			[vim.diagnostic.severity.HINT] = icons.hint,
		},
	},
})

-- Shorten yank highlight duration
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})

-- Colorscheme overrides
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { link = "@comment" })
		vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { link = "@comment" })
		vim.api.nvim_set_hl(0, "WinBar", { link = "SpecialComment" })
	end,
})

-- roslyn_ls runs as a self-contained .NET apphost, so it needs DOTNET_ROOT to
-- locate the runtime. The nix dotnet wrapper only sets this for `dotnet` itself,
-- so resolve it here (through the wrapper symlink) for the whole nvim process.
if vim.env.DOTNET_ROOT == nil and vim.fn.executable("dotnet") == 1 then
	vim.env.DOTNET_ROOT = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.exepath("dotnet")), ":h")
end

-- Enable lsp, configured by lsp-config
vim.lsp.enable("ts_ls")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("gopls")
vim.lsp.enable("cmake")
vim.lsp.enable("lua_ls")
vim.lsp.enable("jsonls")
vim.lsp.enable("yamlls")
vim.lsp.enable("nil_ls")
vim.lsp.enable("roslyn_ls")
vim.lsp.enable("sourcekit")
