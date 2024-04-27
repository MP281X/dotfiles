-- treesitter (syntax hilight)
require("nvim-treesitter.install").compilers = { "gcc" }
require("nvim-treesitter.configs").setup({
	auto_install = true,
	sync_install = false,
	autotag = { enable = true },
	highlight = { enable = true },
	ensure_installed = { "svelte", "typescript", "lua", "bash", "markdown", "json" },
})

-- format on save and keybinds
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf, silent = true }

		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>sa", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "R", vim.lsp.buf.rename, opts)

		vim.cmd [[autocmd BufWritePre * lua pcall(function() vim.cmd("EslintFixAll") end)]]
		pcall(function() vim.lsp.inlay_hint.enable(true, args.buf) end) -- inlay hint
	end,
})

local capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"tsserver", "svelte", "tailwindcss",
		"eslint",
	}
})

require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	settings = { Lua = { diagnostics = { globals = { "vim" } } } }
})

require("lspconfig").tailwindcss.setup({
	capabilities = capabilities,
	filetypes = { "svelte", "typescriptreact" }
})

require("lspconfig").svelte.setup({
	capabilities = capabilities,
	settings = {
		svelte = {
			plugin = {
				typescript = { enable = true },
				svelte = {
					format = {
						enable = false,
						config = { svelteStrictMode = true }
					}
				}
			},
		},
	},
})

require("lspconfig").tsserver.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr) require("twoslash-queries").attach(client, bufnr) end,
	settings = {
		typescript = {
			validate = { enable = true },
			inlayHints = { includeInlayParameterNameHints = "all" },
			tsserver = { experimental = { enableProjectDiagnostics = true } }
		},
		javascript = {
			validate = { enable = true },
			inlayHints = { includeInlayParameterNameHints = "all" }
		},
	},
})

require("lspconfig").eslint.setup({ capabilities = capabilities })

local cmp = require("cmp")
cmp.setup({
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "luasnip", keyword_length = 2 },
	}),
	sorting = {
		comparators = {
			cmp.config.compare.kind,
			cmp.config.compare.exact,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
		},
	},
	snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
	mapping = {
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<Enter>"] = cmp.mapping.confirm({ select = true }),
		["<C-\\>"] = cmp.mapping.complete(),
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

-- formatters
require("conform").setup({
	formatters_by_ft = {
		typescript = { { "prettierd", "prettier" } },
		javascript = { { "prettierd", "prettier" } },
		typescriptreact = { { "prettierd", "prettier" } },
		svelte = { { "prettierd", "prettier" } },
		json = { { "prettierd", "prettier" } },
		yaml = { { "prettierd", "prettier" } }
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_fallback = true,
		async = false,
	},
})
