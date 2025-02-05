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

local job_id = 0
vim.keymap.set('n', '<leader>st', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'L'
  vim.api.nvim_win_set_width(0, 50)

  job_id = vim.bo.channel
end, { desc = 'Open term' })

-- vim.keymap.set('n', '<leader>tt', function()
--   vim.fn.chansend(job_id, 'pnpm jest --runTestsByPath --testPathPattern ' .. vim.fn.expand '%' .. '\r\n')
-- end, { desc = 'Test current file' })

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
