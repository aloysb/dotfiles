-- Shorthand custom command
-- test current file
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'styling changes to terminal',
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

vim.keymap.set('n', '<leader>xx', ':luafile %<CR>', { desc = 'reload lua file' })
