-- treesitter (syntax hilight)
require("nvim-treesitter.configs").setup({
  ensure_installed = { 'lua', 'svelte', 'prisma', 'html', 'typescript', 'bash', 'yaml', 'json' },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true }
})

-- lsp
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'sumneko_lua', 'svelte', 'prismals', 'tsserver', 'bashls', 'yamlls', 'tailwindcss', 'eslint', 'jsonls' }
})

require('lsp-zero').extend_lspconfig()
require('mason-lspconfig').setup_handlers({
  function(server_name)
    if (server_name == "sumneko_lua")
    then
      require("lspconfig").sumneko_lua.setup({
        settings = { Lua = {
          diagnostics = { globals = { 'vim' }, disable = { 'redefined-local' } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false }
        } }
      })
    else
      require('lspconfig')[server_name].setup({})
    end
  end
})

-- Diagnostic
require('lsp-zero').set_sign_icons()
vim.diagnostic.config(require('lsp-zero').defaults.diagnostics({}))

-- Snippet
require('luasnip').config.set_config({
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave'
})

require('luasnip.loaders.from_vscode').lazy_load()

-- Autocompletion
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
local cmp = require('cmp')
local cmp_config = require('lsp-zero').defaults.cmp_config({})

cmp.setup(cmp_config)
