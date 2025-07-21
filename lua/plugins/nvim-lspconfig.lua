-- Install plugins: mason.nvim, nvim-lspconfig
return {
  {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pylsp", "marksman", "bashls", "lua_ls", "rust_analyzer", "matlab_ls", "harper_ls" },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      local ok, local_config = pcall(require, "local_config")
      local notes_path = ok and vim.fs.normalize(local_config.notes_path) or vim.fs.normalize("~/notes")

      lspconfig.lua_ls.setup({ capabilities = capabilities })

      lspconfig.pylsp.setup({
        capabilities = capabilities,
        settings = {
          pylsp = {
            plugins = {
              black = { enabled = true },
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
            }
          }
        }
      })

      lspconfig.nixd.setup({ capabilities = capabilities })

      lspconfig.marksman.setup({
        capabilities = capabilities,
        filetypes = { "markdown" },
        root_dir = function(fname)
          local real_path = vim.fn.fnamemodify(fname, ":p")
          if real_path:find(notes_path, 1, true) == 1 then
            return notes_path
          end
          return util.root_pattern(".markdown.toml", ".git")(fname) or vim.fn.fnamemodify(fname, ":p:h")
        end,
        single_file_support = function(fname)
          local real_path = vim.fn.fnamemodify(fname, ":p")
          if real_path:find(notes_path, 1, true) == 1 then
            return false
          end
          return util.root_pattern(".markdown.toml", ".git")(fname) == nil
        end,
      })

      lspconfig.bashls.setup({ capabilities = capabilities })

      lspconfig.gopls.setup({ capabilities = capabilities })

      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = {
              enable = true,
              command = "clippy",
            },
          },
        },
      })

      lspconfig.matlab_ls.setup({
        cmd = {
          vim.fn.expand(
            "C:\\Users\\charlie\\AppData\\Local\\nvim-data\\mason\\packages\\matlab-language-server\\matlab-language-server.cmd"
          ),
          "--stdio",
          "--matlabInstallPath='C:/Program Files/MATLAB/R2025a'",
        },
        filetypes = { 'matlab' },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
        end,
        capabilities = capabilities,
        settings = {
          MATLAB = {
            indexWorkspace = true,
            matlabConnectionTiming = 'onStart',
            telemetry = true,
          },
        },
        single_file_support = false,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = args.buf,
                  -- Optional: use client ID to format with a specific client
                  filter = function(c)
                    return c.id == client.id
                  end,
                })
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('lint').linters_by_ft = {
        python = { 'pylint' },
        markdown = { 'markdownlint' },
      }
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
  {
    'rshkarin/mason-nvim-lint',
    dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-lint' },
    config = function()
      require('mason-nvim-lint').setup({ automatic_installation = true })
    end
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = { python = { 'black' } },
    }
  },
  {
    'zapling/mason-conform.nvim',
    dependencies = { 'williamboman/mason.nvim', 'stevearc/conform.nvim' },
    config = function()
      require('mason-conform').setup({ ignore_install = {} })
    end
  },
}
