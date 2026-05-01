return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local bufnr = args.buf
          if vim.bo[bufnr].buftype ~= "" then
            return
          end

          pcall(vim.treesitter.start, bufnr)
        end,
      })
    end,
  },
  { "axelvc/template-string.nvim", opts = {} },
  { "echasnovski/mini.pairs",      opts = {} },
}
