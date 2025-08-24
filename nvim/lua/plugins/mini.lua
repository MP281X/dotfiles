return {
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Auto-pairs functionality
      require("mini.pairs").setup()

      -- Session management
      require("mini.sessions").setup({
        autoread = true,
        autowrite = true,
        directory = vim.fn.stdpath('data') .. '/sessions',
        verbose = { read = false, write = false, delete = false },
        hooks = { pre_write = function() if vim.fn.getcwd() == vim.fn.expand("~") then return false end end },
      })

      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          require("lualine").refresh()
        end,
      })
    end,
  },
}
