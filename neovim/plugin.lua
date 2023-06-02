require("lazy").setup({

  -- plugins (start)
  { 'catppuccin/nvim',as = 'catppuccin', lazy = false, priority = 1000 }, -- color scheme

  { 'nvim-telescope/telescope.nvim',  tag = '0.1.1', dependencies = { { 'nvim-lua/plenary.nvim' } } },  -- file search

  { 'nvim-telescope/telescope-file-browser.nvim' }, -- file explorer

  { 'debugloop/telescope-undo.nvim' }, -- undo history

  { 'numToStr/Comment.nvim' }, -- comment code

  { 'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons' }, -- statusline

  { 'numToStr/FTerm.nvim' }, -- floating terminal

  { 'windwp/nvim-autopairs' }, -- auto close ()

  { 'rmagatti/auto-session' }, -- session manager


  -- lsp
  { 'nvim-treesitter/nvim-treesitter' }, -- syntax hilight

  { 'jose-elias-alvarez/null-ls.nvim' }, -- formatter
  
  { 'jay-babu/mason-null-ls.nvim' }, -- auto install tools
  -- lsp zero
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim', build = function() pcall(vim.cmd, 'MasonUpdate') end },
      {'williamboman/mason-lspconfig.nvim'},
  
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  },
}, {})
