return {
  {
    "atiladefreitas/dooing",
    opts = function()
      local save_path = vim.fs.normalize("$USERPROFILE/Documents/notes/dooing_todos.json")

      -- Ensure the directory exists
      local save_dir = vim.fs.dirname(save_path)
      if not vim.loop.fs_stat(save_dir) then
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
