-- treesitter (syntax hilight)
require("nvim-treesitter.configs").setup({
  ensure_installed = { 'lua', 'html', 'bash', 'yaml', 'json', 'rust' },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true }
})

-- lsp
local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

lsp.ensure_installed({ 'lua_ls', 'bashls', 'yamlls', 'rust_analyzer' })

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)


require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- autocomplete
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer',  keyword_length = 3 },
    { name = 'luasnip', keyword_length = 2 },
  },
  mapping = {
    ['<Tab>'] = cmp_action.tab_complete(),
  }
})

-- format
local null_ls = require("null-ls")

null_ls.setup({ sources = { null_ls.builtins.formatting.prettierd } })
