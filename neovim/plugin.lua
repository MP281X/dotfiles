require("lazy").setup({

  -- plugins (start)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },                                                                                                                -- file search

  { 'iamcco/markdown-preview.nvim',    build = function() vim.fn["mkdp#util#install"]() end,     ft = "markdown" }, -- md preview

  { 'windwp/nvim-autopairs',           config = function() require("nvim-autopairs").setup() end },                 -- auto close ()

  { 'numToStr/Comment.nvim',           config = function() require("Comment").setup() end },                        -- comment code

  { 'nvim-lualine/lualine.nvim',       dependencies = 'nvim-tree/nvim-web-devicons' },                              -- statusline

  { 'marilari88/twoslash-queries.nvim' },                                                                           -- show type definition inline (for typescript)

  { 'debugloop/telescope-undo.nvim' },                                                                              -- undo history

  { 'nvim-tree/nvim-tree.lua' },                                                                                    -- file explorer

  { 'windwp/nvim-ts-autotag' },                                                                                     -- auto close <div></div>

  { 'rmagatti/auto-session' },                                                                                      -- session manager

  { 'rebelot/kanagawa.nvim' },                                                                                      -- color scheme

  { 'numToStr/FTerm.nvim' },                                                                                        -- floating terminal

  { 'axelvc/template-string.nvim' },                                                                                -- convert js/ts string to string template


  -- lsp
  { 'nvim-treesitter/nvim-treesitter' }, -- syntax hilight

  { 'jose-elias-alvarez/null-ls.nvim' }, -- non-lsp tools

  { 'jay-babu/mason-null-ls.nvim' },     -- auto install tools

  -- lsp zero
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim',          build = function() pcall(vim.cmd, 'MasonUpdate') end },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
    }
  },
}, {})
