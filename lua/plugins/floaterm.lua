return {
  'voldikss/vim-floaterm',
  vim.keymap.set("n", "<M-i>", vim.cmd.FloatermToggle),
  vim.keymap.set("t", "<M-i>", vim.cmd.FloatermToggle),
}
