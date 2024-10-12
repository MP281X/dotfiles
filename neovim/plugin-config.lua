-- color scheme
require("kanagawa").setup({
	keywordStyle = { italic = false },
	commentStyle = { italic = false },
	colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
	overrides = function(colors)
		local theme = colors.theme
		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
			NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
			LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
			PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
			PmenuSbar = { bg = theme.ui.bg_m1 },
			PmenuThumb = { bg = theme.ui.bg_p2 },
		}
	end,
})
vim.cmd.colorscheme("kanagawa")

-- lua line (statusline)
require("lualine").setup({
	options = {
		theme = "horizon",
		section_separators = "",
		component_separators = "",
		disabled_filetypes = { "packer", "NvimTree" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { { "branch", icon = "󰊢" } },
		lualine_c = { { "buffers", symbols = { modified = " 󱇨", alternate_file = "" } } },
		lualine_x = { "diagnostics" },
		lualine_y = { "filetype" },
		lualine_z = { "location" },
	},
})

-- session manager
require("auto-session").setup({
	log_level = "error",
	auto_session_suppress_dirs = { "~/" },
	cwd_change_handling = { post_cwd_changed_hook = function() require("lualine").refresh() end },
})

require("nvim-autopairs").setup()  -- auto close ()
require('nvim-ts-autotag').setup() -- auto close <></>
require("template-string").setup() -- convert string to string template
