require("lazy").setup({

  -- plugins (start)
  { 'nvim-telescope/telescope.nvim',  tag = '0.1.1', dependencies = { { 'nvim-lua/plenary.nvim' } } },  -- file search

  { 'windwp/nvim-autopairs', config = function() require("nvim-autopairs").setup() end }, -- auto close ()

  { 'numToStr/Comment.nvim', config = function() require("Comment").setup() end }, -- comment code

  { 'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons' }, -- statusline

  { 'nvim-telescope/telescope-file-browser.nvim' }, -- file explorer

  { 'catppuccin/nvim', as = 'catppuccin' }, -- color scheme

  { 'debugloop/telescope-undo.nvim' }, -- undo history

  { 'rmagatti/auto-session' }, -- session manager

  { 'numToStr/FTerm.nvim' }, -- floating terminal


  -- lsp
  { 'nvim-treesitter/nvim-treesitter' }, -- syntax hilight

  { 'jose-elias-alvarez/null-ls.nvim' }, -- non-lsp tools

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
