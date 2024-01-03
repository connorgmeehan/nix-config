local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
			"folke/neodev.nvim",
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
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
        dependencies = { "nvim-treesitter/nvim-treesitter", { "nvim-telescope/telescope-fzf-native.nvim", build = "mkdir -p build && cd build && cmake ../CMakeList.txt && make" } },
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
			require("custom.configs.neo-tree")
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		opts = function()
			local on_attach = require("plugins.configs.lspconfig").on_attach
			local capabilities = require("plugins.configs.lspconfig").capabilities

			require("dap.ext.vscode").load_launchjs(nil, { rt_lldb = { "rust" } })

			local mason_registry = require("mason-registry")
			local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
			local codelldb_path = codelldb_root .. "adapter/codelldb"
			local liblldb_path = codelldb_root .. "lldb/lib/liblldb.dylib"
			local adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)

			local options = {
				server = {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						["rust-analyzer"] = {
							diagnostics = {
								disabled = { "inactive-code" },
							},
							check = {
								allTargets = true,
								allFeatures = true,
								overrideCommand = {
									"cargo",
									"clippy",
									"--workspace",
									"--message-format=json",
									"--all-targets",
									"--all-features",
								},
							},
						},
					},
				},
				dap = { adapter = adapter },
			}

			require("dap").adapters.rust = adapter

			return options
		end,
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
	},

	-- Debugging
	{
		"mfussenegger/nvim-dap",
		config = function()
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapUIStop" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapUIStop" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapUIType" })
			vim.fn.sign_define("DapLogPoint", { text = "󱂅", texthl = "DapUIType" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapUIPlayPause" })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		keys = "<leader>d",
		config = function()
			local dapui = require("dapui")

			dapui.setup()

			local dap = require("dap")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
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
            }
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

	{ "rafcamlet/nvim-luapad", event = "VeryLazy", cmd = "Luapad" },

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

	-- {
	-- 	"metakirby5/codi.vim",
	-- 	cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
	-- 	config = function()
	-- 		vim.cmd([[
	--        let g:codi#interpreters = {
	--          \ 'deno': {
	--            \ 'bin': ['deno'],
	--            \ 'prompt': '^\(>\|\.\.\.\+\) ',
	--            \ },
	--         \ }
	--      ]])
	-- 	end,
	-- },
	-- {
	-- 	"michaelb/sniprun",
	-- 	opts = {
	-- 		live_mode_toggle = "enable", --# live mode toggle, see Usage - Running for more info
	--      selected_interpreters={"JS_TS_deno"},
	--      repl_enable={"JS_TS_deno"}
	-- 	},
	--    cmd = { "SnipRun", "SnipInfo", "SnipReset", "SnipLive" },
	-- 	keys = {
	-- 		{ "<leader>rr", "<cmd>SnipRun<cr>" },
	-- 		{ "<leader>rr", "<cmd>'<,'>SnipRun<cr>", mode = "v" },
	-- 		{ "<leader>rR", "<cmd>lua require’sniprun’.reset()<cr>" },
	-- 		{ "<leader>rl", "<cmd>lua require’sniprun.live_mode’.toggle()<cr>" },
	-- 	},
	-- },
    {
      "dccsillag/magma-nvim",
      build = ":UpdateRemotePlugins",
          keys = {
              { "<leader>r", "<cmd>MagmaEvaluateOperator<cr>", expr = true, silent = true },
              { "<leader>r", "<cmd><C-u>MagmaEvaluateVisual", mode = "v" },
              { "<leader>rr", "<cmd>MagmaEvaluateLine<cr>" },
              { "<leader>rq", "<cmd>MagmaDelete<cr>" },
              { "<leader>ro", "<cmd>MagmaShowOutput<cr>" },
          },
    },

    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
      opts = {
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
      },
    },

    {
        "f-person/git-blame.nvim",
        cmd = { "GitBlameToggle", "GitBlameEnable", "GitBlameDisable" },
        opts = {
          enabled = true,
        },
      }
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
						{ "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
						{ "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
						{ "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
						{ "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
						{ "b", gitsigns.blame_line, { desc = "blame" } },
						{
							"B",
							function()
								gitsigns.blame_line({ full = true })
							end,
							{ desc = "blame show full" },
						},
						{ "/", gitsigns.show, { exit = true, desc = "show base file" } }, -- show the base of the file
						{ "<Enter>", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
						{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
					},
				})
			end

            configure_git_hydra()
		end,
        keys = { "<leader>G" },
	},
}

return plugins
