-- treesitter (syntax hilight)
require('nvim-treesitter.install').compilers = { 'gcc' }
require("nvim-treesitter.configs").setup({
  ensure_installed = { 'rust', 'svelte', 'typescript', 'lua', 'yaml', 'json', 'toml' },
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
  'rust_analyzer',
  'svelte',
  'tsserver',
  'eslint',
})

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
