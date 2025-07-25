return {
  {
    "atiladefreitas/dooing",
    opts = function()
      -- Attempt to load a local config with secrets (like your notes path)
      local ok, local_config = pcall(require, "local_config")

      -- Default fallback if local_config doesn't exist
      local notes_path = ok and local_config.notes_path or vim.fn.expand("~/notes")

      -- Construct save path
      local save_path = notes_path .. "/dooing_todos.json"

      -- Ensure the directory exists
      local save_dir = vim.fs.dirname(save_path)
      if save_dir and not vim.loop.fs_stat(save_dir) then
        vim.fn.mkdir(save_dir, "p")
      end

      return {
        save_path = save_path,
        window = {
          width = 60,
          height = 20,
          border = "rounded",
        },
        icons = {
          pending = "○",
          done = "✓",
        },
        keymaps = {
          toggle_window = "<A-t>", -- Alt+t to open/close
          new_todo      = "i",
          toggle_todo   = "x",
          delete_todo   = "d",
          close_window  = "q",
        },
      }
    end,
    config = function(_, opts)
      require("dooing").setup(opts)
    end,
    keys = {
      { "<A-t>", "<cmd>Dooing<CR>", desc = "Toggle Dooing todos" },
    },
  },
}
