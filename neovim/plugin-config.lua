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
		lualine_b = {
			{
				"branch",
				icon = "󰊢",
				fmt = function(str)
					if string.find(str, "/") then
						local branch = vim.split(str, "/")[2]
						branch = vim.split(branch, "-")
						return branch[1] .. "-" .. branch[2]
					else
						return str
					end
				end,
			},
		},
		lualine_c = { { "buffers", symbols = { modified = " 󱇨", alternate_file = "" } } },
		lualine_x = { "diagnostics" },
		lualine_y = { "filetype" },
		lualine_z = { "location" },
	},
})

-- floating terminal
require("FTerm").setup({
	auto_close = false,
	cmd = (function()
		-- node
		if vim.fn.findfile("package.json") ~= "" then return { "node", "--no-warnings", "--run", "dev" } end
		if vim.fn.findfile("deno.json") ~= "" then return { "deno", "task", "-q", "dev" } end

		return { "sh", "-c", "$SHELL" }
	end)(),
})

-- session manager
require("auto-session").setup({
	log_level = "error",
	auto_session_suppress_dirs = { "~/" },
	cwd_change_handling = { post_cwd_changed_hook = function() require("lualine").refresh() end },
})

-- convert js/ts string to string template
require("template-string").setup({
	filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "svelte" },
	jsx_brackets = true,
	remove_template_string = true,
	restore_quotes = { normal = [[']], jsx = [["]] },
})

-- git integration
require('gitsigns').setup({
	signcolumn = false,
	numhl = true,
	current_line_blame = true,
	preview_config = { border = 'rounded' }
})

require("Comment").setup()         -- comment code
require("nvim-autopairs").setup()  -- auto close ()
require('nvim-ts-autotag').setup() -- auto close <></>
