return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-16" }

      -- tsgo
      vim.lsp.config("tsgo", {
        capabilities = capabilities,
      })
      vim.lsp.enable("tsgo")

      -- Biome
      vim.lsp.config("biome", { capabilities = capabilities })
      vim.lsp.enable("biome")

      -- Tailwind CSS
      vim.lsp.config("tailwindcss", { capabilities = capabilities })
      vim.lsp.enable("tailwindcss")

      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = { Lua = { diagnostics = { globals = { "vim" } } } }
      })
      vim.lsp.enable("lua_ls")

      -- Diagnostics
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "x",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "»",
          },
        },
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        float = { source = "always", border = "rounded" },
        severity_sort = true,
        update_in_insert = false,
      })

      -- Keybinds
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          vim.keymap.set("n", "<leader>gd", require('telescope.builtin').lsp_definitions, opts)
          vim.keymap.set("n", "<leader>gr", require('telescope.builtin').lsp_references, opts)
          vim.keymap.set("n", "<leader>gi", require('telescope.builtin').lsp_implementations, opts)
          vim.keymap.set("n", "<leader>gt", require('telescope.builtin').lsp_type_definitions, opts)
          vim.keymap.set("n", "<leader>sa", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "R", vim.lsp.buf.rename, opts)

          if client and client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end

          -- Disable heavy features for snappiness
          if client then
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentHighlightProvider = false
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.jsonc", "*.html", "*.css" },
        callback = function()
          vim.lsp.buf.format({ filter = function(c) return c.name == "biome" end, timeout_ms = 1000 })
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.lua",
        callback = function()
          vim.lsp.buf.format({ filter = function(c) return c.name == "lua_ls" end, timeout_ms = 1000 })
        end,
      })
    end,
  },
}
