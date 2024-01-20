-- treesitter (syntax hilight)
require('nvim-treesitter.install').compilers = { 'gcc' }
require('nvim-treesitter.configs').setup({
	ensure_installed = { 'svelte', 'typescript', 'javascript', 'lua', 'bash', 'markdown', 'astro' },
	sync_install = false,
	auto_install = true,
	highlight = { enable = true },
	autotag = { enable = true },
})

-- lsp
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
	lsp.buffer_autoformat()

	-- typescript type viewer // ^?
	require("twoslash-queries").attach(client, bufnr)

	-- inlay hint
	pcall(function() vim.lsp.inlay_hint.enable() end)
end)

lsp.ensure_installed({
	'lua_ls',                 -- lua
	'tsserver', 'tailwindcss', -- node
	'svelte', 'astro',        -- framework
})

require('lspconfig').lua_ls.setup({ settings = { Lua = { diagnostics = { globals = { 'vim' } } } } })

require('lspconfig').tailwindcss.setup({ filetypes = { 'svelte', 'typescriptreact', 'astro' } })

require('lspconfig').svelte.setup({
	settings = {
		svelte = {
			plugin = {
				svelte = {
					defaultScriptLanguage = "ts",
					format = { config = { svelteStrictMode = true } },
				}
			}
		}
	}
})

require('lspconfig').tsserver.setup({
	settings = {
		typescript = { inlayHints = { includeInlayParameterNameHints = 'all' } },
		javascript = { inlayHints = { includeInlayParameterNameHints = 'all' } }
	}
})

lsp.setup()

-- autocomplete
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
	sources = {
		{ name = 'path' },
		{ name = 'nvim_lsp' },
		-- { name = 'buffer',  keyword_length = 5 },
		{ name = 'luasnip', keyword_length = 2 },
	},
	sorting = {
		comparators = {
			cmp.config.compare.kind,
			cmp.config.compare.exact,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
		}
	},
	mapping = {
		['<Tab>'] = cmp_action.tab_complete(),
		['<Enter>'] = cmp.mapping.confirm({ select = true }),
		['<C-\\>'] = cmp.mapping.complete(),
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	}
})

local null_ls = require('null-ls')
local null_ls_languages = {
	'javascript', 'typescript', 'typescriptreact',
	'astro', 'svelte', 'html', 'css',
	'json', 'yaml'
}


null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier.with({ filetypes = null_ls_languages }),
		null_ls.builtins.diagnostics.eslint.with({ filetypes = null_ls_languages, only_local = "node_modules/.bin" }),
	}
})
require('mason-null-ls').setup({ ensure_installed = nil, automatic_installation = true })
