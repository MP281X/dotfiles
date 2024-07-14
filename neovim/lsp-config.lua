-- treesitter (syntax hilight)
require("nvim-treesitter.install").compilers = { "gcc" }
require("nvim-treesitter.configs").setup({
	auto_install = true,
	sync_install = false,
	highlight = { enable = true }
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

		pcall(function() vim.lsp.inlay_hint.enable(true) end) -- inlay hint
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local filetype = vim.bo[bufnr].filetype

		if (filetype == "svelte") then return end

		vim.lsp.buf.format({
			filter = function(client)
				if client.name == "tsserver" then return false end

				return true
			end
		})
	end
})

local capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "lua_ls", "tsserver", "svelte", "biome", "astro" } })

require("lspconfig").astro.setup({ capabilities = capabilities })
require("lspconfig").svelte.setup({ capabilities = capabilities })
require("lspconfig").biome.setup({ capabilities = capabilities })
require("lspconfig").tailwindcss.setup({ capabilities = capabilities })

require("lspconfig").lua_ls.setup({ capabilities = capabilities, settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

require("lspconfig").tsserver.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr) require("twoslash-queries").attach(client, bufnr) end,
	settings = {
		typescript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
		javascript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
	},
})

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

-- formatters
require("conform").setup({
	formatters_by_ft = { svelte = { { "prettier" } } },
	format_on_save = {
		timeout_ms = 1000,
		lsp_fallback = true,
		async = false,
	},
})
