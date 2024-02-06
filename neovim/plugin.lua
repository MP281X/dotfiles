require("lazy").setup({
	{ -- file search
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},
	{ -- statusline
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
	{ -- md preview
		ft = "markdown",
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	{ "marilari88/twoslash-queries.nvim" },       -- show type definition inline (for typescript)
	{ "debugloop/telescope-undo.nvim" },          -- undo history
	{ "axelvc/template-string.nvim" },            -- convert js/ts string to string template
	{ "nvim-tree/nvim-tree.lua" },                -- file explorer
	{ "windwp/nvim-ts-autotag" },                 -- auto close <div></div>
	{ "windwp/nvim-autopairs" },                  -- auto close ()
	{ "numToStr/Comment.nvim" },                  -- comment code
	{ "rmagatti/auto-session" },                  -- session manager
	{ "rebelot/kanagawa.nvim" },                  -- color scheme
	{ "numToStr/FTerm.nvim" },                    -- floating terminal
	{ "nvim-telescope/telescope-ui-select.nvim" }, -- use telescope for the vim.ui.select ui
	{ "lewis6991/gitsigns.nvim" },                -- git integration


	-- language tools
	{ "nvim-treesitter/nvim-treesitter",        build = ":TSUpdate" }, -- syntax hilight
	{ 'stevearc/conform.nvim' },                                      -- formatter

	-- lsp tools
	{ "williamboman/mason-lspconfig.nvim" }, -- configure lsp installed by mason
	{ "williamboman/mason.nvim" },          -- lsp manager
	{ "neovim/nvim-lspconfig" },            -- lsp server

	-- Autocompletion
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/nvim-cmp" },
	{ "L3MON4D3/LuaSnip" },
	{ "hrsh7th/cmp-path" },
}, {})
