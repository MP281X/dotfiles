local winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.install").compilers = { "gcc" }
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        sync_install = false,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
      })
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Enter>"] = { "accept", "fallback" },
        ["<C-\\>"] = { "show", "fallback" },
      },
      sources = { default = { "lsp", "path" } },
      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
      signature = { enabled = true, window = { border = "rounded", winhighlight = winhighlight } },
      completion = {
        menu = { border = "rounded", winhighlight = winhighlight, draw = { treesitter = { "lsp" } } },
        documentation = { window = { border = "rounded", winhighlight = winhighlight } },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
  {
    "axelvc/template-string.nvim",
    config = function()
      require("template-string").setup()
    end,
  },
}
