-- Neovim Configuration Entry Point
-- Bootstrap Lazy.nvim plugin manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration
require("core.options")
require("core.keymaps")

-- Load plugins
require("lazy").setup({
  { import = "plugins.ui" },
  { import = "plugins.editor" },
  { import = "plugins.lsp" },
  { import = "plugins.files" },
  { import = "plugins.terminal" },
  { import = "plugins.sessions" },
}, { 
  change_detection = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin", 
        "tohtml",
        "zipPlugin",
        "netrwPlugin",
      }
    }
  }
})
