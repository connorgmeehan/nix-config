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
					checkOnSave = {
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
			char = "│",
			filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
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
    opts = {},
  }
}

return plugins
