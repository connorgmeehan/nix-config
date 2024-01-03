-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.opt.relativenumber = true
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Indent 4 spaces
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.opt.synmaxcol = 500;
vim.opt.wrap = false;

-- Fix for https://github.com/nvim-telescope/telescope.nvim/issues/699
-- Files opened with telescope wont fold.
vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "BufWinEnter"  }, {
  group = vim.api.nvim_create_augroup("ts_fold_workaround", { clear = true }),
  command = "set foldexpr=nvim_treesitter#foldexpr()",
})

-- Fix Neogit highlight
vim.api.nvim_set_hl(0, 'NeogitDiffDelete', { fg = "#bf565f", bg = "#261f1f" })
vim.api.nvim_set_hl(0, 'NeogitDiffDeleteHighlight', { fg = "#d8616b", bg = "#342a2a" })
