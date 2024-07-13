local overrides = require("configs.overrides")

---@type NvPluginSpec[]
local plugins = {
    {
      "stevearc/conform.nvim",
      disable = true,
    },
    -- Override plugin definition options
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- format & linting
            {
                "nvimtools/none-ls.nvim",
                config = function()
                    require("configs.null-ls")
                end,
            },
            "folke/neodev.nvim",
            "folke/neoconf.nvim",
        },
        config = function()
            require("configs.lspconfig")
        end, -- Override to setup mason-lspconfig
    },

    -- override plugin configs
    {
        "williamboman/mason.nvim",
        opts = overrides.mason,
    },

    -- load luasnips + cmp related in insert mode only
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                -- snippet plugin
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                config = function(_, opts)
                    require("luasnip").config.set_config(opts)
                    require "nvchad.configs.luasnip"
                end,
            },

            -- autopairing of (){}[] etc
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)

                    -- setup cmp for autopairs
                    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
                    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
            },

            -- cmp sources plugins
            {
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-nvim-lsp-signature-help"
            },
        },
        opts = function()
            local cfg = require "nvchad.configs.cmp";
            table.insert(cfg.sources, { name = "nvim_lsp_signature_help" })
            return cfg
        end,
        config = function(_, opts)
            require("cmp").setup(opts)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = overrides.nvimtree,
        enabled = false,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            -- Disabled, use zf-native instead
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                enabled = false,
                build = "mkdir -p build && cd build && cmake ../CMakeList.txt && make",
            },
            {
                "natecraddock/telescope-zf-native.nvim",
                config = function()
                    require("telescope").load_extension("zf-native")
                end
            }
        },
        opts = {
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "-L",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
                prompt_prefix = "   ",
                selection_caret = "  ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                file_sorter = require("telescope.sorters").get_fuzzy_file,
                file_ignore_patterns = { "node_modules" },
                generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
                path_display = { "truncate" },
                winblend = 0,
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                -- Developer configurations: Not meant for general override
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                mappings = {
                    n = { ["q"] = require("telescope.actions").close },
                },
            },

            extensions_list = { "themes", "terms" },
            extensions = {"zf-native"},
        }
    },

    {
        "folke/neodev.nvim",
        opts = {
            override = function(root_dir, library)
                print(root_dir .. " " .. vim.inspect(library))
                if root_dir:find("paddynvim", 1, true) == 1 then
                    library.enabled = true
                    library.plugins = true
                end
            end,
        },
    },
    {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        config = true,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        config = function()
            require("configs.neo-tree")
        end,
    },

    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            -- char = "▏",
            exclude = {
                filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
            },
        },
        main = "ibl",
    },

    -- Winbar status line
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        event = "VeryLazy",
        config = true,
        opts = {
            -- configurations go here
        },
    },

    {
        "echasnovski/mini.nvim",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.surround").setup({
                mappings = {
                    add = "ys", -- Add surrounding in Normal and Visual modes
                    delete = "ds", -- Delete surrounding
                    highlight = "vs", -- Highlight surrounding
                    replace = "cs", -- Replace surrounding
                },
            })
            require("mini.comment").setup()
        end,
    },

    {
        "connorgmeehan/paddynvim",
        branch = "feat/impl-draw-integration",
        event = "VeryLazy",
        cmd = "Paddy",
        config = function()
            local cpml = require("paddynvim.integrations.cpml")
            local draw = require("paddynvim.integrations.draw")

            require("paddynvim").setup({
                integrations = { cpml, draw },
            })
        end,
    },

    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        keys = "<leader>cf",
        cmd = "Neogen",
        config = true,
        -- Uncomment next line if you want to follow only stable versions
        version = "*",
    },

    {
        "RaafatTurki/hex.nvim",
        config = function()
            require("hex").setup()
        end,
        cmd = { "HexDump", "HexAssemble", "HexToggle" },
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^4', -- Recommended
        ft = { 'rust' },
    },

    {
        "dccsillag/magma-nvim",
        build = ":UpdateRemotePlugins",
        keys = {
            { "<leader>r",  "<cmd>MagmaEvaluateOperator<cr>", expr = true, silent = true },
            { "<leader>r",  "<cmd><C-u>MagmaEvaluateVisual",  mode = "v" },
            { "<leader>rr", "<cmd>MagmaEvaluateLine<cr>" },
            { "<leader>rq", "<cmd>MagmaDelete<cr>" },
            { "<leader>ro", "<cmd>MagmaShowOutput<cr>" },
        },
    },

    -- Neogit for hydra git mode.
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim", -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- Required for fuzz searching
        },
        config = true,
        cmd = "Neogit",
    },

    {
        "anuvyklack/hydra.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
        },
        config = function()
            local configure_git_hydra = function()
                local Hydra = require("hydra")
                local gitsigns = require("gitsigns")

                local hint = [[
                 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
                 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _B_: blame show full
                 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
                 ^
                 ^ ^              _<Enter>_: Neogit              _q_: exit
                ]]

                Hydra({
                    name = "Git",
                    hint = hint,
                    config = {
                        buffer = bufnr,
                        color = "pink",
                        invoke_on_body = true,
                        hint = {
                            border = "rounded",
                        },
                        on_enter = function()
                            vim.cmd("mkview")
                            vim.cmd("silent! %foldopen!")
                            vim.bo.modifiable = false
                            gitsigns.toggle_signs(true)
                            gitsigns.toggle_linehl(true)
                        end,
                        on_exit = function()
                            local cursor_pos = vim.api.nvim_win_get_cursor(0)
                            vim.cmd("loadview")
                            vim.api.nvim_win_set_cursor(0, cursor_pos)
                            vim.cmd("normal zv")
                            gitsigns.toggle_signs(false)
                            gitsigns.toggle_linehl(false)
                            gitsigns.toggle_deleted(false)
                        end,
                    },
                    mode = { "n", "x" },
                    body = "<leader>G",
                    heads = {
                        {
                            "J",
                            function()
                                if vim.wo.diff then
                                    return "]c"
                                end
                                vim.schedule(function()
                                    gitsigns.next_hunk()
                                end)
                                return "<Ignore>"
                            end,
                            { expr = true, desc = "next hunk" },
                        },
                        {
                            "K",
                            function()
                                if vim.wo.diff then
                                    return "[c"
                                end
                                vim.schedule(function()
                                    gitsigns.prev_hunk()
                                end)
                                return "<Ignore>"
                            end,
                            { expr = true, desc = "prev hunk" },
                        },
                        { "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "stage hunk" } },
                        { "u", gitsigns.undo_stage_hunk,   { desc = "undo last stage" } },
                        { "S", gitsigns.stage_buffer,      { desc = "stage buffer" } },
                        { "p", gitsigns.preview_hunk,      { desc = "preview hunk" } },
                        { "d", gitsigns.toggle_deleted,    { nowait = true, desc = "toggle deleted" } },
                        { "b", gitsigns.blame_line,        { desc = "blame" } },
                        {
                            "B",
                            function()
                                gitsigns.blame_line({ full = true })
                            end,
                            { desc = "blame show full" },
                        },
                        { "/",       gitsigns.show,     { exit = true, desc = "show base file" } }, -- show the base of the file
                        { "<Enter>", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
                        { "q",       nil,               { exit = true, nowait = true, desc = "exit" } },
                    },
                })
            end

            configure_git_hydra()
        end,
        keys = { "<leader>G" },
    },

    {
        "alexghergh/nvim-tmux-navigation",
        opts = true,
        keys = {
            { "<C-h>",     "<cmd>NvimTmuxNavigateLeft<cr>",       silent = true },
            { "<C-j>",     "<cmd>NvimTmuxNavigateDown<cr>",       silent = true },
            { "<C-k>",     "<cmd>NvimTmuxNavigateUp<cr>",         silent = true },
            { "<C-l>",     "<cmd>NvimTmuxNavigateRight<cr>",      silent = true },
            { "<C-/>",     "<cmd>NvimTmuxNavigateLastActive<cr>", silent = true },
            { "<C-Space>", "<cmd>NvimTmuxNavigateNext<cr>",       silent = true },
        },
    },
}

return plugins
