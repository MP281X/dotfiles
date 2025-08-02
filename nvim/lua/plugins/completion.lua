local winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
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
    dependencies = {
      "rafamadriz/friendly-snippets",
      "fang2hou/blink-copilot"
    },
    version = "*",
    opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Enter>"] = { "accept", "fallback" },
        ["<C-\\>"] = { "show", "fallback" },
      },
      cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },
      completion = {
        menu = { border = "rounded", winhighlight = winhighlight, auto_show = true, draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true, auto_show_delay_ms = 0, window = { border = "rounded", winhighlight = winhighlight } },
      },
      sources = {
        default = { "lsp", "path", "copilot" },
        providers = { copilot = { name = "copilot", module = "blink-copilot", score_offset = 100, async = true } },
      },
      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
      signature = { enabled = true, window = { border = "rounded", winhighlight = winhighlight } },
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
