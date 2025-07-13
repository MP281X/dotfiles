return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls", "biome", "tailwindcss"
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )

      -- LSP server configurations
      vim.lsp.config("biome", { capabilities = capabilities })
      vim.lsp.config("tailwindcss", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = { Lua = { diagnostics = { globals = { "vim" } } } }
      })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        settings = {
          typescript = { inlayHints = { includeInlayParameterNameHints = "literals" } },
          javascript = { inlayHints = { includeInlayParameterNameHints = "literals" } }
        }
      })

      -- Enhanced diagnostic configuration
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "x",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "»",
          },
        },
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        float = {
          source = "always",
          border = "rounded",
        },
        severity_sort = true,
        update_in_insert = false,
      })

      -- LSP keybinds
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- Enhanced keymaps
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<leader>sa", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "R", vim.lsp.buf.rename, opts)

          -- Enable inlay hints if supported
          if client and client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end

          -- disable lsp syntax highlight for better performance
          if client then
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentHighlightProvider = false
          end
        end,
      })

      -- format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.lsp.buf.format({ filter = function(client) return client.name ~= "ts_ls" end })
        end
      })
    end,
  },
}
