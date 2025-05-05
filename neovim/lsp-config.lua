-- treesitter (syntax hilight)
require("nvim-treesitter.install").compilers = { "gcc" }
require("nvim-treesitter.configs").setup({
	auto_install = true,
	sync_install = false,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
})

-- keybinds
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf, silent = true }

		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>sa", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "R", vim.lsp.buf.rename, opts)

		vim.lsp.inlay_hint.enable(true) -- inlay hint

		-- disable lsp syntax highlight
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		client.server_capabilities.semanticTokensProvider = nil
		client.server_capabilities.documentHighlightProvider = false
	end,
})

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ filter = function(client) return client.name ~= "tsserver" end })
	end
})

local capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

local languageConfig = {
	ts_ls = { root_dir = require("lspconfig").util.root_pattern("package.json"), single_file_support = false },
	biome = { root_dir = require("lspconfig").util.root_pattern("biome.json") },
}

local languageSettings = {
	Lua = { diagnostics = { globals = { "vim" } } },
	biome = { rename = true, experimental = { rename = true } },
	typescript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
	javascript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
	svelte = {
		enableTsPlugin = true,
		plugin = { svelte = { defaultScriptLanguage = "ts" } }
	}
}

local lspSetup = function(server_name)
	local config = languageConfig[server_name] or {}
	require("lspconfig")[server_name].setup(
		vim.tbl_deep_extend("force", config, {
			capabilities = capabilities,
			settings = languageSettings
		})
	)
end

-- base lsp config
require("mason").setup()
require("mason-lspconfig").setup({
	handlers = { lspSetup },

	ensure_installed = {
		"lua_ls",
		"ts_ls", "svelte", "biome", "tailwindcss", "prismals",
	}
})

-- autocomplete
require("cmp").setup({
	sources = require("cmp").config.sources({
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "luasnip", keyword_length = 2 },
	}),
	sorting = {
		comparators = {
			require("cmp").config.compare.kind,
			require("cmp").config.compare.exact,
			require("cmp").config.compare.recently_used,
			require("cmp").config.compare.locality,
		},
	},
	snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
	mapping = {
		["<Tab>"] = require("cmp").mapping.select_next_item(),
		["<up>"] = require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),
		["<down>"] = require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),
		["<Enter>"] = require("cmp").mapping.confirm({ select = true }),
		["<C-\\>"] = require("cmp").mapping.complete(),
	},
	window = {
		completion = require("cmp").config.window.bordered(),
		documentation = require("cmp").config.window.bordered(),
	},
})

local dap = require("dap")

-- Set keymaps to control the debugger
vim.keymap.set('n', '<leader>d', require('dap').continue)
vim.keymap.set('n', '<leader>dd', require('dap').step_over)
vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoint)
vim.keymap.set('n', 'D', require('dap.ui.widgets').hover)
vim.keymap.set('v', 'D', require('dap.ui.widgets').hover)

vim.fn.sign_define('DapBreakpoint', { text = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '' })

dap.adapters = {
	["pwa-node"] = {
		type = "server",
		host = "127.0.0.1",
		port = 8123,
		executable = { command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter" },
	},
	["pwa-chrome"] = {
		type = "server",
		host = "127.0.0.1",
		port = 8123,
		executable = { command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter" },
	}
}
for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
	require("dap").configurations[language] = {
		{
			name = "node",
			type = "pwa-node",
			request = "attach",
			cwd = "${workspaceFolder}",
		},
		{
			name = "vite",
			type = "pwa-chrome",
			request = "attach",
			port = 9222,
			url = "http://localhost:5173",
			webRoot = "${workspaceFolder}/src",
			sourceMaps = true
		},
	}
end
