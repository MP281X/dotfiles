-- nvim-tree (file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup({ view = { side = "right", hide_root_folder = true } })

-- auto close ()
require("nvim-autopairs").setup()

-- floating terminal
require("FTerm").setup({ cmd = "pwsh -noLogo" })

-- telescope (fuzzy finder)
require("telescope").setup()

-- comment
require("Comment").setup()

-- lua line (statusline)
require("lualine").setup({
  options = {
    theme = "horizon",
    section_separators = "",
    component_separators = "",
    disabled_filetypes = { "packer", "NvimTree" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
})

-- treesitter (syntax hilight)
require("nvim-treesitter.configs").setup({
  ensure_installed = { 'lua', 'svelte', 'prisma', 'html', 'typescript', 'bash', 'yaml' },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true }
})

-- lsp
require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { 'svelte', 'prismals', 'tsserver', 'bashls', 'yamlls', 'tailwindcss', 'eslint' }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
  vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format, {})
end

require("lspconfig").svelte.setup({ on_attach = on_attach, capabilities = capabilities })
require("lspconfig").prismals.setup({ on_attach = on_attach, capabilities = capabilities })
require("lspconfig").tsserver.setup({ on_attach = on_attach, capabilities = capabilities })
require("lspconfig").bashls.setup({ on_attach = on_attach, capabilities = capabilities })
require("lspconfig").yamlls.setup({ on_attach = on_attach, capabilities = capabilities })
require("lspconfig").tailwindcss.setup({ on_attach = on_attach, capabilities = capabilities })
require("lspconfig").eslint.setup({ on_attach = on_attach, capabilities = capabilities })

-- autocomplete with icon
require('lspkind').init({mode = 'symbol_text', preset = 'codicons'})
local cmp = require('cmp')
cmp.setup({
  sources = {{ name = 'nvim_lsp' }},
  formatting = {format = require('lspkind').cmp_format({ellipsis_char = '...'})},
  mapping = {
    -- Confirm selections with tab
    ['<Enter>'] = cmp.mapping(function(fallback)
      if cmp.visible()
      then cmp.confirm({ select = true })
      else fallback()
      end
    end, {'i', 'c'}),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item({
      behavior = cmp.SelectBehavior.Select
    }), {'i', 'c'}),
  }
})

-- eslint
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })

      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

require("prettier").setup({
  bin = 'prettier',
  filetypes = {
    "css",
    "html",
    "json",
    "markdown",
    "typescript",
    "yaml",
    "svelte",
  },
})
