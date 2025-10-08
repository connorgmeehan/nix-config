local overrides = require("configs.overrides")

---@type NvPluginSpec[]
local plugins = {
    {
        "nvchad/ui",
        config = function()
            require "nvchad"
        end
    },

    {
        "nvchad/base46",
        lazy = true,
        build = function()
            require("base46").load_all_highlights()
        end,
    },

    {
        "stevearc/conform.nvim",
        config = function()
            local config = require("configs.conform")
            require("conform").setup(config)
        end,
        keys = {
            {
                "<leader>fm",
                function()
                    require("conform").format({ async = true })
                end,
                desc = "Format buffer"
            }
        },
        cmd = "ConformInfo"
    },

    -- Override plugin definition options
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/neodev.nvim",
            "folke/neoconf.nvim",
        },
        config = function()
            return require("configs.lspconfig")
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
            table.insert(cfg.sources, { name = "copilot" })
            return cfg
        end,
        config = function(_, opts)
            require("cmp").setup(opts)
        end,
    },

    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        config = function()
            require("typescript-tools").setup({
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
            })
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
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "marilari88/neotest-vitest",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-vitest"),
                }
            })
        end
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
            extensions = { "zf-native" },
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
                    add = "ys",       -- Add surrounding in Normal and Visual modes
                    delete = "ds",    -- Delete surrounding
                    highlight = "vs", -- Highlight surrounding
                    replace = "cs",   -- Replace surrounding
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

    {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            -- OR 'ibhagwan/fzf-lua',
            -- OR 'folke/snacks.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require "octo".setup({
                use_local_fs = true,
                mappings_disable_default = false
            })
        end,
        cmd = "Octo",
        keys = {
            { "<leader>opl", "<cmd>Octo pr list<cr>",         desc = "List PRs" },
            { "<leader>opC", "<cmd>Octo pr create<cr>",       desc = "Create PR" },
            { "<leader>opc", "<cmd>Octo pr checkout<cr>",     desc = "Checkout PR from list" },
            { "<leader>opu", "<cmd>Octo pr url<cr>",          desc = "Copy url" },

            { "<leader>ors", "<cmd>Octo review start<cr>",    desc = "Start review" },
            { "<leader>orS", "<cmd>Octo review submit<cr>",   desc = "Submit review" },
            { "<leader>orx", "<cmd>Octo review close<cr>",    desc = "Close review" },
            { "<leader>ord", "<cmd>Octo review discard<cr>",  desc = "Discard review" },
            { "<leader>orr", "<cmd>Octo review resume<cr>",   desc = "Resume review" },
            { "<leader>orc", "<cmd>Octo review commit<cr>",   desc = "Review a single commit" },
            { "<leader>orp", "<cmd>Octo review comments<cr>", desc = "Preview pending comments" },

            { "<leader>oca", "<cmd>Octo comment add<cr>",     desc = "Add comment" },
            { "<leader>ocs", "<cmd>Octo comment suggest<cr>", desc = "Add suggestion" },
            { "<leader>ocd", "<cmd>Octo comment delete<cr>",  desc = "Delete comment" },
            { "<leader>ocu", "<cmd>Octo comment url<cr>",     desc = "Copy url" },
        }
    },

    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            vim.schedule(function()
                require('colorizer').setup()
            end)
        end,
        event = "VeryLazy",
    },

    {
        "alexghergh/nvim-tmux-navigation",
        event = 'VeryLazy',
        config = function()
            require('nvim-tmux-navigation').setup({})
        end,
        keys = {
            { "<C-h>",     "<cmd>NvimTmuxNavigateLeft<cr>",       silent = true },
            { "<C-j>",     "<cmd>NvimTmuxNavigateDown<cr>",       silent = true },
            { "<C-k>",     "<cmd>NvimTmuxNavigateUp<cr>",         silent = true },
            { "<C-l>",     "<cmd>NvimTmuxNavigateRight<cr>",      silent = true },
            { "<C-/>",     "<cmd>NvimTmuxNavigateLastActive<cr>", silent = true },
            { "<C-Space>", "<cmd>NvimTmuxNavigateNext<cr>",       silent = true },
        },
    },

    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        opts = {
            -- I don't find the panel useful.
            panel = { enabled = false },
            suggestion = {
                auto_trigger = true,
                -- Use alt to interact with Copilot.
                keymap = {
                    -- Disable the built-in mapping, we'll configure it in nvim-cmp.
                    accept = false,
                    accept_word = '<M-w>',
                    accept_line = '<M-l>',
                    next = '<M-]>',
                    prev = '<M-[>',
                    dismiss = '/',
                },
            },
            filetypes = { markdown = true },
        },
        config = function(_, opts)
            local cmp = require 'cmp'
            local copilot = require 'copilot.suggestion'
            local luasnip = require 'luasnip'

            require('copilot').setup(opts)

            local function set_trigger(trigger)
                vim.b.copilot_suggestion_auto_trigger = trigger
                vim.b.copilot_suggestion_hidden = not trigger
            end

            -- Hide suggestions when the completion menu is open.
            -- cmp.event:on('menu_opened', function()
            --     if copilot.is_visible() then
            --         copilot.dismiss()
            --     end
            --     set_trigger(false)
            -- end)

            -- Disable suggestions when inside a snippet.
            cmp.event:on('menu_closed', function()
                set_trigger(not luasnip.expand_or_locally_jumpable())
            end)
            vim.api.nvim_create_autocmd('User', {
                pattern = { 'LuasnipInsertNodeEnter', 'LuasnipInsertNodeLeave' },
                callback = function()
                    set_trigger(not luasnip.expand_or_locally_jumpable())
                end,
            })
        end,
    },

    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
    },

    {
        "gabrielpoca/replacer.nvim",
        opts = { rename_files = false },
        keys = {
            {
                '<leader>ce',
                function() require('replacer').run({ save_on_write = true, rename_files = true }) end,
                desc = "Start editing quickfix"
            },
        }
    },

    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        dependencies = {
            "artemave/workspace-diagnostics.nvim",
        },
        keys = {
            {
                "<leader>tw",
                function()
                    for _, client in ipairs(vim.lsp.buf_get_clients()) do
                        require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
                    end
                    vim.notify("Workspace diagnostics populated")
                end,
                desc = "Populates workspace diagnostics"
            },
            {
                "<leader>tt",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>tb",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>ts",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>tL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>tq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },

    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
            "DiffviewFileHistory",
        },
    },
}

return plugins
