-- treesitter (syntax hilight)
require("nvim-treesitter.configs").setup({
  ensure_installed = { 'lua', 'svelte', 'prisma', 'html', 'typescript', 'bash', 'yaml', 'json' },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true }
})

-- lsp
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
