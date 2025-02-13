local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "json5",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "hcl"
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
    -- the related part.
  highlight = {
    enable = true,
    language_tree = true,
    is_supported = function ()
      if vim.fn.strwidth(vim.fn.getline('.')) > 2000
        or vim.fn.getfsize(vim.fn.expand('%')) > 1024 * 1024 then
        return false
      else
        return true
      end
    end
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",
    "tailwind-css",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "deno",
    "prettier",
    "tailwindcss-language-server",
    "rustywind",
    "vue-language-server",
    "svelte-language-server",

    "terraform-ls",
    "tf-lint",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
