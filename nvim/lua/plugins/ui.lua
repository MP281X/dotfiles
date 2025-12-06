return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        keywordStyle = { italic = false },
        commentStyle = { italic = false },
        colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "horizon",
          section_separators = "",
          component_separators = "",
          disabled_filetypes = { "lazy", "NvimTree" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { { "branch", icon = "󰊢" } },
          lualine_c = {
            {
              "buffers",
              symbols = { modified = " 󱇨", alternate_file = "" },
              buffers_color = {
                active = { fg = "#c0caf5", bg = "#1a1b26" },
                inactive = { fg = "#565f89", bg = "#1a1b26" },
              },
              fmt = function(name, context)
                local full_path = context.bufpath or vim.api.nvim_buf_get_name(context.bufnr)
                if full_path == "" then return name end

                local display_name = (name == "index.ts" or name == "index.tsx")
                    and vim.fn.fnamemodify(full_path, ":h:t") .. "/"
                    or name

                local cwd = vim.fn.getcwd()
                local dir = vim.fn.fnamemodify(full_path, ":h")

                while dir ~= "/" do
                  if vim.fn.filereadable(dir .. "/package.json") == 1 then
                    if dir == cwd then return display_name end
                    return vim.fn.fnamemodify(dir, ":t") .. "/" .. display_name
                  end
                  dir = vim.fn.fnamemodify(dir, ":h")
                end

                return display_name
              end
            }
          },
          lualine_x = { "diagnostics" },
          lualine_y = { "filetype" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
