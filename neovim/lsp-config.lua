-- treesitter (syntax hilight)
require('nvim-treesitter.install').compilers = { 'gcc' }
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'rust', 'go', 'svelte', 'typescript', 'lua' },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true }
})

-- lsp
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.ensure_installed({
  'rust_analyzer', -- rust
  'gopls', -- golang
  'svelte', 'tsserver', 'tailwindcss', -- sveltekit
})

require('lspconfig').tailwindcss.setup({
  filetypes = { 'svelte' }
})

local format_cfg = {
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['null-ls'] = {'javascript', 'typescript', 'svelte'},
  }
}

lsp.format_on_save(format_cfg)
lsp.format_mapping('<leader>ff', format_cfg)

lsp.setup()

-- autocomplete
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = {
    ['<Tab>'] = cmp_action.tab_complete(),
    ['<Enter>'] = cmp.mapping.confirm({ select = true }),
    ['<C-\\>'] = cmp.mapping.complete(),
  }
})

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd.with({
      filetypes = {'javascript', 'typescript', 'svelte'},
    }),
    null_ls.builtins.code_actions.eslint_d.with({
      filetypes = {'javascript', 'typescript', 'svelte'},
    }),
    null_ls.builtins.diagnostics.buf,
  }
})

require('mason-null-ls').setup({
  ensure_installed = nil,
  automatic_installation = true,
})
