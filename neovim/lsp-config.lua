-- treesitter (syntax hilight)
require("nvim-treesitter.install").compilers = { "gcc" }
require("nvim-treesitter.configs").setup({
	auto_install = true,
	sync_install = false,
	highlight = { enable = true }
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

		pcall(function() vim.lsp.inlay_hint.enable(true) end) -- inlay hint
	end,
})

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({ filter = function(client) return client.name ~= "tsserver" end })
	end
})

-- base lsp config
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "svelte", "biome", "prismals", "tsserver" } })

local capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

-- specific lsp configs
require("lspconfig").svelte.setup({ capabilities = capabilities })
require("lspconfig").prismals.setup({ capabilities = capabilities })
require("lspconfig").tailwindcss.setup({ capabilities = capabilities })
require("lspconfig").lua_ls.setup({ capabilities = capabilities, settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
require("lspconfig").biome.setup({ capabilities = capabilities })

require("lspconfig").denols.setup({
	capabilities = capabilities,
	filetypes = { "typescriptreact", "typescript", "json", "jsonc" },
	on_attach = function(client, bufnr) require("twoslash-queries").attach(client, bufnr) end,
	root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
	settings = {
		deno = {
			inlayHints = {
				parameterTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				propertyDeclarationTypes = { enabled = true },
			},
		}
	}
})

require("lspconfig").tsserver.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr) require("twoslash-queries").attach(client, bufnr) end,
	root_dir = require("lspconfig").util.root_pattern("package.json"),
	settings = {
		typescript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
		javascript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
	},
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
