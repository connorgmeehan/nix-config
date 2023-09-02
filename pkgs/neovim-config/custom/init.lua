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

vim.opt.synmaxcol = 500;
vim.opt.wrap = false;

-- Fix for https://github.com/nvim-telescope/telescope.nvim/issues/699
-- Files opened with telescope wont fold.
vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "BufWinEnter"  }, {
  group = vim.api.nvim_create_augroup("ts_fold_workaround", { clear = true }),
  command = "set foldexpr=nvim_treesitter#foldexpr()",
})
