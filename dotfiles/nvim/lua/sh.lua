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

-- test in split
vim.keymap.set('n', '<leader>tt', function()
  vim.fn.jobstart({
    'wezterm',
    'cli',
    'split-pane',
    '--right',
    '--percent',
    '30',
    '--',
    'pnpm',
    'jest',
    '--coverage=true',
    '--reports="text',
    '--runTestsByPath',
    '--testPathPattern',
    '--watch',
    vim.fn.expand '%',
  }, { detach = true })
end, { desc = 'Test current file' })
