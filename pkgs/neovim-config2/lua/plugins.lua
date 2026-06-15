return {
	-- LSP + Highlighting
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/neodev.nvim", ft = "lua" },
			"folke/neoconf.nvim",
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		},
		config = function()
			require("nvim-treesitter").install({
				"bash",
				"css",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			})

			-- Enable highlighting + indentation per buffer when a parser is available
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not (lang and vim.treesitter.language.add(lang)) then
						return
					end
					vim.treesitter.start(args.buf, lang)
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			-- Textobjects (main branch requires explicit setup + keymaps)
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			for key, obj in pairs({
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			}) do
				vim.keymap.set({ "x", "o" }, key, function()
					select.select_textobject(obj, "textobjects")
				end, { desc = "Select " .. obj })
			end

			for key, obj in pairs({ ["]f"] = "@function.outer", ["]c"] = "@class.outer" }) do
				vim.keymap.set({ "n", "x", "o" }, key, function()
					move.goto_next_start(obj, "textobjects")
				end, { desc = "Next " .. obj })
			end

			for key, obj in pairs({ ["[f"] = "@function.outer", ["[c"] = "@class.outer" }) do
				vim.keymap.set({ "n", "x", "o" }, key, function()
					move.goto_previous_start(obj, "textobjects")
				end, { desc = "Prev " .. obj })
			end
		end,
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},

	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "enter" },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = true } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		opts = {
			mappings = {
				["o"] = "open",
				["c"] = "copy",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["?"] = "show_help",
				["a"] = {
					"add",
					config = {
						show_path = "none",
					},
				},
			},
		},
		lazy = false, -- neo-tree will lazily load itself
		keys = {
			{ "<leader>e", "<cmd>:Neotree filesystem reveal left toggle<CR>" },
			{ "<leader>E", "<cmd>:Neotree filesystem reveal left<CR>" },
		},
	},
	{
		"Crysthamus/nvim-file-operations",
		-- branch = "compat" -- if you are on Neovim <= 0.10
		dependencies = {
			"nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
		},
		config = function()
			require("nvim-file-operations").setup()
		end,
	},

	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			-- downloads a prebuilt binary or falls back to cargo build
			require("fff.download").download_or_build_binary()
		end,
		opts = {
			debug = {
				enabled = true,
				show_scores = true,
			},
		},
		lazy = false, -- the plugin lazy-initialises itself
		keys = {
			{
				"<leader>ff",
				function()
					require("fff").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fg",
				function()
					require("fff").live_grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>fw",
				function()
					require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
				end,
				desc = "Live fffuzy grep",
			},
			{
				"<leader>fc",
				function()
					require("fff").live_grep({ query = vim.fn.expand("<cword>") })
				end,
				desc = "Search current word",
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
		opts = {
			enhanced_diff_hl = true,
			default_args = { -- Default args prepended to the arg-list for the listed commands
				DiffviewOpen = { "--imply-local" },
				DiffviewFileHistory = {},
			},
		},
		keys = {
			{ "<leader>do", "<cmd>DiffviewOpen<CR>", "Open diff view" },
			{ "<leader>dd", "<cmd>DiffviewOpen develop..HEAD<CR>", "Open diff view" },
			{ "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", "Open file history" },
			{ "<leader>dc", "<cmd>DiffviewClose<CR>", "Close diff view" },
			{
				"<leader>dl",
				function()
					require("diffview.actions").cycle_layout()
				end,
				"Change layout",
			},
		},
		setup = true,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					python = { "black" },
					rust = { "rustfmt" },
					go = { "gofmt" },
					nix = { "nixpkgs-fmt" },
					json = { "prettierd", "prettier", stop_after_first = true },
					yaml = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettierd", "prettier", stop_after_first = true },
					css = { "prettierd", "prettier", stop_after_first = true },
				},
			})
		end,
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true })
				end,
				desc = "Format buffer",
			},
		},
		cmd = "ConformInfo",
	},

	{
		"mfussenegger/nvim-lint",
		setup = function()
			require("lint")
		end,
	},

	-- Misc
	{
		"echasnovski/mini.nvim",
		version = false,
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
			require("mini.pairs").setup()
			require("mini.tabline").setup()

			local MiniStatusline = require("mini.statusline")
			require("mini.statusline").setup({
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local git = MiniStatusline.section_git({ trunc_width = 40 })
						local diff = MiniStatusline.section_diff({ trunc_width = 75 })
						local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
						local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
						local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local location = '%l:%L %2v:%-2{virtcol("$") - 1}'

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
							"%<", -- Mark general truncate point
							{ hl = "MiniStatuslineFilename", strings = { filename } },
							"%=", -- End left alignment
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { location } },
						})
					end,
				},
				use_icons = true,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{

		"lewis6991/gitsigns.nvim",
		keys = {
			{
				"<leader>gn",
				"<cmd>Gitsigns next_hunk<CR>",
				desc = "Next hunk",
			},
			{
				"<leader>gp",
				"<cmd>Gitsigns prev_hunk<CR>",
				desc = "Prev hunk",
			},
			{
				"<leader>gb",
				"<cmd>Gitsigns blame_line<CR>",
				desc = "Blame line",
			},
			{
				"<leader>gB",
				"<cmd>Gitsigns blame<CR>",
				desc = "Blame",
			},
			{
				"<leader>gq",
				"<cmd>Gitsigns setqflist<CR>",
				desc = "Quickfix",
			},
		},
		config = true,
	},

	-- Winbar breadcrumbs
	{
		"bekaboo/dropbar.nvim",
		event = "VeryLazy",
		opts = {
			icons = {
				ui = {
					bar = {
						seperator = "󰍟",
					},
				},
			},
		},
	},

	-- { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons", config = true },

	{
		"alexghergh/nvim-tmux-navigation",
		event = "VeryLazy",
		config = function()
			require("nvim-tmux-navigation").setup({})
		end,
		keys = {
			{ "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", silent = true },
			{ "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", silent = true },
			{ "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", silent = true },
			{ "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", silent = true },
			{ "<C-/>", "<cmd>NvimTmuxNavigateLastActive<cr>", silent = true },
			{ "<C-Space>", "<cmd>NvimTmuxNavigateNext<cr>", silent = true },
		},
	},

	-- Themes
	{
		"ember-theme/nvim",
		name = "ember",
		priority = 1000,
		config = function()
			require("ember").setup({
				variant = "ember", -- "ember" | "ember-soft" | "ember-light"
				styles = {
					keywords = {
						bold = false,
					},
				},
			})
			vim.cmd("colorscheme ember")
		end,
	},
}
