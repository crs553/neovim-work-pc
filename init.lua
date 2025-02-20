require("config.lazy")
require("cs-config")

vim.cmd.colorscheme "catppuccin-mocha"

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

require('lualine').setup {}


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- In terminal compiling (unused as you can't do this with matlab)
-- local job_id = 0

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Customise terminal opening',
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false

    -- In terminal compiling (unused as you can't do this with matlab)
    -- job_id = vim.bo.channel
  end,
})

vim.keymap.set("n", "<leader>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end)
