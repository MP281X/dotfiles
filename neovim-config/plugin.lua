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
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
  
      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }
}, {
  install = { colorscheme = { "catppuccin" }, missing = true }
})
