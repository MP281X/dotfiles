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

local file_filters = {
	--global
	".git", ".gitignore", ".vscode",
	-- node
	"node_modules", "dist", "build",
	-- package managers
	"pnpm-workspace.yaml", "pnpm-lock.yaml", "bun.lockb", ".npmrc",
	-- js/ts (others)
	"prettier.config.js", "eslint.config.js",
	-- sveltekit
	".svelte-kit", "svelte.config.js", "vite.config.ts",
	-- nextjs
	".next", "next-env.d.ts",
	-- tailwind
	"tailwind.config.js", "postcss.config.js", "postcss.config.cjs",
	-- typescript (codegen)
	"tsconfig.tsbuildinfo",
	-- others
	".eslintcache", ".attest"
}

local regexify_array = function(arr)
	local regex_arr = {}
	for _, item in ipairs(arr) do
		table.insert(regex_arr, "^" .. item .. "$")
	end
	return regex_arr
end

-- file explorer
require("nvim-tree").setup({
	filters = { custom = regexify_array(file_filters), exclude = { ".github" } },
	view = { side = "right", width = 60 },
	update_focused_file = { enable = true },
	git = { enable = true, ignore = false, timeout = 500 },
	renderer = { root_folder_label = false, icons = { show = { git = false } } },
})

-- telescope (fuzzy finder)
require("telescope").setup({
	defaults = {
		file_ignore_patterns = file_filters,
		mappings = {
			i = {
				["<Tab>"] = require('telescope.actions').move_selection_next,
				["<S-Tab>"] = require('telescope.actions').move_selection_previous,
			}
		}
	},
	pickers = { find_files = { hidden = true }, live_grep = { hidden = true } },
	extensions = {
		["ui-select"] = { require("telescope.themes").get_dropdown({}) },
		undo = {
			use_delta = true,
			side_by_side = true,
			diff_context_lines = 15,
			entry_format = "[$ID]: $TIME",
			mappings = {
				i = {
					["<leader>y"] = require("telescope-undo.actions").yank_additions,
					["<leader>d"] = require("telescope-undo.actions").yank_deletions,
					["<cr>"] = require("telescope-undo.actions").restore,
				},
			},
		},
	},
})

require("telescope").load_extension("undo")      -- undo tree
require("telescope").load_extension("ui-select") -- replace select panel with telescope

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
		if vim.fn.findfile("bun.lockb") ~= "" then return { "bun", "run", "--silent", "dev" } end
		if vim.fn.findfile("package.json") ~= "" then return { "node", "--run", "dev" } end

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
	preview_config = { border = 'rounded' },
	yadm = { enable = false }
})

require("Comment").setup()        -- comment code
require("nvim-autopairs").setup() -- auto close ()
