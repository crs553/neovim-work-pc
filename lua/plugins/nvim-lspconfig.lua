return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {             -- for lua lsp
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- autocompletion
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- lua
      require("lspconfig").lua_ls.setup { capabilites = capabilities }

      --python
      require 'lspconfig'.pylsp.setup { capabilites = capabilities }

      --markdown
      require 'lspconfig'.marksman.setup { capabilites = capabilities }

      --matlab
      require 'lspconfig'.matlab_ls.setup {
        cmd = { 'matlab-language-server', '--stdio', '--matlabInstallPath="C:\\Program Files\\MATLAB\\R2024b"' },
        filetypes = { 'matlab' },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
        end,
        capabilites = capabilities,
        settings = {
          MATLAB = {
            indexWorkspace = true,
            matlabConnectionTiming = 'onStart',
            matlabInstallPath = "C:\\Program Files\\MATLAB\\R2024b",
            telemetry = true,
          },
        },
        single_file_support = false,
      }

      --autoformat on save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          if client.supports_method('textDocument/formatting') then
            -- format the current buffer onsave
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })

            -- Create a keymap for vim.lsp.buf.rename()
          end
        end
      })
    end,
  }
}
