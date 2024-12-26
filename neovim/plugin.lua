require("lazy").setup({
	{ -- file search
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
	{ -- statusline
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
	},

	{ "debugloop/telescope-undo.nvim" },          -- undo history
	{ "axelvc/template-string.nvim" },            -- convert js/ts string to string template
	{ "nvim-tree/nvim-tree.lua" },                -- file explorer
	{ "windwp/nvim-ts-autotag" },                 -- auto close <div></div>
	{ "windwp/nvim-autopairs" },                  -- auto close ()
	{ "rmagatti/auto-session" },                  -- session manager
	{ "numToStr/FTerm.nvim" },                    -- floating terminal
	{ "nvim-telescope/telescope-ui-select.nvim" }, -- use telescope for the vim.ui.select ui

	-- theme
	{ "rebelot/kanagawa.nvim" },                                      -- color scheme
	{ "nvim-treesitter/nvim-treesitter",        build = ":TSUpdate" }, -- syntax hilight

	-- lsp tools
	{ "williamboman/mason-lspconfig.nvim" }, -- configure lsp installed by mason
	{ "williamboman/mason.nvim" },          -- lsp manager
	{ "neovim/nvim-lspconfig" },            -- lsp server

	-- debugger
	{ "mfussenegger/nvim-dap" }, -- debugger

	-- Autocomplete
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip" },
	{ "hrsh7th/cmp-path" },
}, {})
