-- treesitter (syntax hilight)
require('nvim-treesitter.install').compilers = { 'gcc' }
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'svelte', 'typescript', 'javascript', 'lua' },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true },
  autotag = { enable = true },
})

-- lsp
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
  if vim.fn.findfile("yarn.lock") ~= "yarn.lock" then lsp.buffer_autoformat() end
  require("twoslash-queries").attach(client, bufnr)
end)

lsp.ensure_installed({
  'lua_ls',                            -- lua
  'svelte', 'tsserver', 'tailwindcss', -- sveltekit
  'angularls', 'html',                 -- angular
})

require('lspconfig').tailwindcss.setup({ filetypes = { 'svelte', 'html' } })
require('lspconfig').lua_ls.setup({ settings = { Lua = { diagnostics = { globals = { 'vim' } } } } })

lsp.setup()

-- autocomplete
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer',  keyword_length = 5 },
    { name = 'luasnip', keyword_length = 2 },
  },
  sorting = {
    comparators = {
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality
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
local null_ls_languages = { 'javascript', 'typescript', 'svelte', 'html', 'css', 'json' }
null_ls.setup({
  sources = (function()
    local ls = { null_ls.builtins.code_actions.eslint_d.with({ filetypes = null_ls_languages }) }

    if vim.fn.findfile("yarn.lock") ~= "yarn.lock" then
      table.insert(ls, null_ls.builtins.formatting.prettierd.with({ filetypes = null_ls_languages }))
    end

    return ls
  end)()
})
require('mason-null-ls').setup({ ensure_installed = nil, automatic_installation = true })
