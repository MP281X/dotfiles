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

local languageSettings = {
	Lua = { diagnostics = { globals = { "vim" } } },
	deno = { inlayHints = { parameterNames = { enabled = "literals" } } },
	typescript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
	javascript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
}

local lspSetup = function(server_name, config)
	config = config or {}

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
		"pyright",
		"jdtls", "kotlin_language_server",
		"ts_ls", "svelte", "biome", "tailwindcss", "prismals",
	}
})

lspSetup("denols", {
	filetypes = { "typescriptreact", "typescript", "json", "jsonc" },
	root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
})

lspSetup("ts_ls", {
	single_file_support = false,
	root_dir = require("lspconfig").util.root_pattern("package.json"),
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
