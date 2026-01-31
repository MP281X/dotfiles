return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.install").compilers = { "gcc" }
      require("nvim-treesitter").setup({
        auto_install = true,
        sync_install = false,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
      })
    end,
  },
  { "windwp/nvim-ts-autotag",      opts = {} },
  { "axelvc/template-string.nvim", opts = {} },
  { "echasnovski/mini.pairs",      opts = {} },
}
