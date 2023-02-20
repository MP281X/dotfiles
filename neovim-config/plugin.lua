-- lazy nvim configuration
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- plugins (start)
  { 'catppuccin/nvim', as = 'catppuccin', lazy = false, priority = 1000 }, -- color scheme

  { 'nvim-telescope/telescope.nvim', tag = '0.1.1', dependencies = { { 'nvim-lua/plenary.nvim' } } }, -- file search

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }, -- file browser

  { 'numToStr/Comment.nvim' }, -- comment code

  { 'nvim-lualine/lualine.nvim' }, -- statusline

  { 'numToStr/FTerm.nvim' }, -- floating terminal

  { 'windwp/nvim-autopairs' }, -- auto close ()

  { 'nvim-treesitter/nvim-treesitter' }, -- syntax hilight

  -- lsp
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      { 'williamboman/mason.nvim' }, -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' }, -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'hrsh7th/cmp-buffer' }, -- Optional
      { 'hrsh7th/cmp-path' }, -- Optional
      { 'saadparwaiz1/cmp_luasnip' }, -- Optional
      { 'hrsh7th/cmp-nvim-lua' }, -- Optional

      -- Snippets
      { 'L3MON4D3/LuaSnip' }, -- Required
      { 'rafamadriz/friendly-snippets' }, -- Optional
    }
  }
}, {
  install = { colorscheme = { "catppuccin" }, missing = true }
})
