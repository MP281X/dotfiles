local permanent_filters = {
	--global
	".git", ".gitignore", ".vscode",
	-- node
	"node_modules", "dist", "build",
	-- package managers
	"pnpm-lock.yaml", "bun.lockb",
	-- sveltekit/nextjs
	".svelte-kit", ".next", "next-env.d.ts",
	-- js/ts configs
	"postcss.config.js", "postcss.config.cjs",
	-- cache
	".eslintcache", ".attest", "*.tsbuildinfo",
	-- c#
	"obj", "bin"
}

local conditional_filters = {
	-- global
	".github",
	-- package managers
	"pnpm-workspace.yaml", ".npmrc",
	-- js/ts configs
	"prettier.config.js", "eslint.config.js", "tsconfig.json",
	"tailwind.config.js", "app.css", "globals.css",
	-- sveltekit
	"svelte.config.js", "app.d.ts", "app.html",
	-- nextjs
	"vite.config.ts", "next.config.js",
	-- solidjs
	"entry-client.tsx", "entry-server.tsx", "global.d.ts",
	-- astrojs
	"astro.config.mjs", "env.d.ts",
	-- codegen
	"*.g.ts",
	-- c#
	"*.csproj", "*.sln", "appsettings.json", "Properties"
}

local nvimTreeFilters = function()
	local filters = {}
	if Enable_filters then
		filters = vim.list_extend(permanent_filters, conditional_filters)
	else
		filters = permanent_filters
	end

	local regex_arr = {}
	for _, item in ipairs(filters) do
		if item:sub(1, 1) == "*" then item = item:sub(2) else item = "^" .. item end
		if item:sub(-1) == "*" then item = item:sub(1, -2) else item = item .. "$" end

		table.insert(regex_arr, item)
	end
	return regex_arr
end

local telescopeFilters = function(args)
	local filters = {}
	if Enable_filters then
		filters = vim.list_extend(permanent_filters, conditional_filters)
	else
		filters = permanent_filters
	end

	for _, pattern in ipairs(filters) do
		table.insert(args, '-g')
		table.insert(args, '!' .. pattern)
	end
	return args
end

-- file explorer
require("nvim-tree").setup({
	filters = { custom = nvimTreeFilters() },
	view = { side = "right", width = 60 },
	update_focused_file = { enable = true },
	git = { enable = true, ignore = false, timeout = 500 },
	renderer = { root_folder_label = false, icons = { show = { git = false } } },
})

-- telescope (fuzzy finder)
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<Tab>"] = require('telescope.actions').move_selection_next,
				["<S-Tab>"] = require('telescope.actions').move_selection_previous,
			}
		}
	},
	pickers = {
		live_grep = { additional_args = telescopeFilters({ '--hidden', '--no-ignore' }) },
		find_files = { find_command = telescopeFilters({ 'rg', '--files', '--hidden', '--no-ignore' }) },
	},
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
