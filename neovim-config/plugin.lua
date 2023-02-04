-- packer installation
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end


require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- plugins (start)
  use { 'catppuccin/nvim', as = 'catppuccin' } -- color scheme

  use { 'nvim-telescope/telescope.nvim', tag = '0.1.1', requires = { { 'nvim-lua/plenary.nvim' } } } -- file search

  use 'numToStr/Comment.nvim' -- comment code

  use { 'nvim-lualine/lualine.nvim' } -- statusline

  use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' }, tag = 'nightly' } -- file explorer

  use { 'numToStr/FTerm.nvim' } -- floating terminal

  use { 'windwp/nvim-autopairs' } -- auto close ()

  use { 'nvim-treesitter/nvim-treesitter' } -- syntax hilight

  use { 'onsails/lspkind-nvim' } -- autocomplete icon

  -- lsp
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }
  use { 'neovim/nvim-lspconfig' }

  -- auto complete
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/nvim-cmp' }

  -- formatter 
  use{ 'jose-elias-alvarez/null-ls.nvim' }
  use{ 'MunifTanjim/prettier.nvim' }

  -- plugins (end)
end)
