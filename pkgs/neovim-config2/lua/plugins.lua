local icons = require("constants").icons
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
			filesystem = {
				follow_current_file = { enabled = true },
			},
			window = {
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
		},
		lazy = false, -- neo-tree will lazily load itself
		keys = {
			{ "<leader>e", "<cmd>:Neotree filesystem reveal left toggle<CR>" },
			{ "<leader>E", "<cmd>:Neotree filesystem reveal left<CR>" },
			{ "<leader>ge", "<cmd>:Neotree git_status reveal left toggle<CR>" },
		},
	},
	{
		"Crysthamus/nvim-file-operations",
		event = "VeryLazy",
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
		version = "0.9.*",
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
			{
				"<leader>fp",
				"<CMD>:FFFResume<CR>",
				desc = "Resume",
			},
		},
	},

	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
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
			{ "<leader>do", "<cmd>DiffviewOpen<CR>", desc = "Open diff view" },
			{ "<leader>dd", "<cmd>DiffviewOpen develop..HEAD<CR>", desc = "Diff with develop" },
			{ "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", desc = "Open file history" },
			{ "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
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
		event = "VeryLazy",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					-- python = { "black" },
					rust = { "rustfmt" },
					-- go = { "gofmt" },
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
				function(args)
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "Format buffer",
			},
		},
		cmd = "ConformInfo",
	},

	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
		event = "VeryLazy",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					require("none-ls.diagnostics.eslint_d"),
					require("none-ls.code_actions.eslint_d"),
				},
			})
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
					highlight = "sa", -- Highlight surrounding
					replace = "cs", -- Replace surrounding
				},
			})
			require("mini.comment").setup()
			require("mini.pairs").setup()
			require("mini.tabline").setup()

			local MiniStatusline = require("mini.statusline")

			local badge = function(icon, label_fn)
				return function()
					local label = label_fn()
					if label == nil then
						return ""
					end

					return icon .. " " .. label
				end
			end

			local repo_name = badge(icons.folder, function()
				local status = vim.b.gitsigns_status_dict
				if status and status.root then
					return vim.fn.fnamemodify(status.root, ":t")
				end
			end)

			local branch_name = badge(icons.branch, function()
				local status = vim.b.gitsigns_status_dict
				if status and status.head then
					return status.head
				end
			end)

			local dirty = badge(icons.plus_minus, function()
				local status = vim.b.gitsigns_status_dict
				if status and status.added and status.changed and status.removed then
					local changes = status.added + status.changed + status.removed
					if changes > 0 then
						return changes
					end
				end
			end)

			require("mini.statusline").setup({
				content = {
					active = function()
						local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
						local diagnostics = MiniStatusline.section_diagnostics({
							trunc_width = 75,
							icon = "",
							signs = {
								ERROR = icons.error .. " ",
								WARN = icons.warn .. " ",
								INFO = icons.info .. " ",
								HINT = icons.hint .. " ",
							},
						})
						local lsp = MiniStatusline.section_lsp({ icon = icons.language, trunc_width = 75 })
						-- local filename = MiniStatusline.section_filename({ trunc_width = 140 })
						local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
						local short_location = "%l:%2v"

						return MiniStatusline.combine_groups({
							{ hl = mode_hl, strings = { mode } },
							{
								hl = "MiniStatuslineDevinfo",
								strings = { lsp },
							},
							"%<", -- Mark general truncate point
							{
								hl = "MiniStatuslineFilename",
								strings = { repo_name(), branch_name(), dirty() },
							},
							"%=", -- End left alignment
							{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
							{ hl = mode_hl, strings = { short_location } },
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
		event = "VeryLazy",
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
			{
				"<leader>gR",
				"<cmd>Gitsigns reset_hunk<CR>",
				desc = "Reset hunk",
			},
		},
		config = true,
	},

	-- Winbar breadcrumbs
	{
		"bekaboo/dropbar.nvim",
		event = "VeryLazy",
		config = true,
		keys = {
			{
				"<leader>tb",
				function()
					if vim.o.winbar == "" then
						vim.o.winbar = "%{%v:lua.dropbar()%}"
					else
						vim.o.winbar = ""
					end
				end,
				desc = "Breadcrumbs",
			},
		},
	},

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
				on_highlights = function(highlights, theme)
					highlights["NeoTreeWinSeparator"].fg = theme.ui.base4
					highlights["NeoTreeWinSeparator"].bg = theme.ui.bg_alt

					-- highlights["FloatBorder"] = { fg = theme.ui.base1, bg = theme.ui.base0 }
					highlights["@function"].fg = theme.syn.sage
					highlights["@function.call"].fg = theme.syn.steel
				end,
			})
			vim.cmd("colorscheme ember")
		end,
	},
}
