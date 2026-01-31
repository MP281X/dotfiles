local winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"

return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = { "show_and_insert", "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Enter>"] = { "accept", "fallback" },
        ["<C-\\>"] = { "show", "fallback" },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "none",
          ["<Tab>"] = { "show_and_insert", "select_next", "fallback" },
          ["<S-Tab>"] = { "show_and_insert", "select_prev", "fallback" },
        },
        completion = { menu = { auto_show = false } },
      },
      completion = {
        menu = { border = "rounded", auto_show = true, winhighlight = winhighlight },
        documentation = { auto_show = true, auto_show_delay_ms = 0, window = { border = "rounded", winhighlight = winhighlight } },
        list = { selection = { preselect = true, auto_insert = true } },
      },
      sources = { default = { "lsp", "path" } },
      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
      signature = { enabled = true, window = { border = "rounded", winhighlight = winhighlight } },
    },
  },
}
