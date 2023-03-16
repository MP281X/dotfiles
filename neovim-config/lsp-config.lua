-- treesitter (syntax hilight)
require("nvim-treesitter.configs").setup({
  ensure_installed = { 'lua', 'svelte', 'prisma', 'html', 'typescript', 'bash', 'yaml', 'json' },
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

lsp.ensure_installed({ 'lua_ls', 'svelte', 'prismals', 'tsserver', 'bashls', 'yamlls', 'tailwindcss', 'eslint' })

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)


require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
