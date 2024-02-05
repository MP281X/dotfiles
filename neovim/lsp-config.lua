-- treesitter (syntax hilight)
require("nvim-treesitter.install").compilers = { "gcc" }
require("nvim-treesitter.configs").setup({
	auto_install = true,
	sync_install = false,
	autotag = { enable = true },
	highlight = { enable = true },
	ensure_installed = { "svelte", "typescript", "lua", "bash", "markdown" },
})

-- format on save and keybinds
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(e)
		local opts = { buffer = e.buf, silent = true }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "A", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "R", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, opts)
	end,
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "tsserver", "svelte", "tailwindcss" },
	-- setup default settings for every lsp
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = vim.tbl_deep_extend(
					"force",
					{},
					vim.lsp.protocol.make_client_capabilities(),
					require("cmp_nvim_lsp").default_capabilities()
				),
				on_attach = function(client, bufnr)
					pcall(vim.lsp.inlay_hint.enable)             -- inlay hint
					require("twoslash-queries").attach(client, bufnr) -- typescript type viewer // ^?
				end,
			})
		end,
	},
})

require("lspconfig").lua_ls.setup({ settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

require("lspconfig").tailwindcss.setup({ filetypes = { "svelte", "typescriptreact", "astro" } })

require("lspconfig").svelte.setup({
	settings = {
		svelte = {
			plugin = {
				svelte = {
					typescript = { enable = true },
					config = { svelteStrictMode = true },
				},
			},
		},
	},
})

require("lspconfig").tsserver.setup({
	settings = {
		typescript = { inlayHints = { includeInlayParameterNameHints = "all" } },
		javascript = { inlayHints = { includeInlayParameterNameHints = "all" } },
	},
})

local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "luasnip", keyword_length = 2 },
	},
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

-- null ls
local null_ls = require("null-ls")
local null_ls_languages = {
	"javascript",
	"typescript",
	"typescriptreact",
	"astro",
	"svelte",
	"html",
	"css",
	"json",
	"yaml",
}

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettierd.with({ filetypes = null_ls_languages }),
		null_ls.builtins.diagnostics.eslint_d.with({ filetypes = null_ls_languages }),
	},
})

require("mason-null-ls").setup({
	ensure_installed = { "prettierd", "eslint_d" },
	automatic_installation = true,
})
