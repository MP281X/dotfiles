-- treesitter (syntax hilight)
require('nvim-treesitter.install').compilers = { 'gcc' }
require("nvim-treesitter.configs").setup({
  ensure_installed = { 'rust', 'svelte', 'typescript', 'lua', 'toml' },
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
})

local format_config = {
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['null-ls'] = {'javascript', 'typescript', 'lua'},
  }
}

lsp.format_mapping('gq', format_config)
lsp.format_on_save(format_config)

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
null_ls.setup({})

require('mason-null-ls').setup({
  automatic_installation = true,
  ensure_installed = {'eslint_d', 'prettierd'},
})
