-- [[ Basic Keymaps ]]

-- Copy/Paste for wayland - Won't work on mac
vim.keymap.set({ 'n' }, '<C-V>', ':r !wl-paste<CR>', { desc = "Paste" })
vim.keymap.set({ 'v' }, '<C-V>', '<Esc> :r !wl-paste<CR>', { desc = "Paste" })
vim.keymap.set({ 'v' }, '<C-C>', ':w !wl-copy<CR>', { desc = "Copy" })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>w', '<cmd>:w!', { desc = "Save" })
vim.keymap.set('n', '<leader>wq', '<cmd>:w!q', { desc = "Save" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- buffers
vim.keymap.set('n', '<leader>bb', '<cmd>b#<CR>', { desc = 'Toggle buffer back/forth' })

-- Toggle LSP diagnostics
vim.keymap.set('n', '<leader>td', '<cmd>lua ToggleDiagnostics()<CR>', { desc = 'Toggle LSP Diagnostics' })

-- better vertical nav - center the active line after scrolling half a page
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll upwards' })

-- save
vim.keymap.set('n', '<leader>w', ':w!<enter>', { desc = 'Save', noremap = false })

-- quit
vim.keymap.set('n', '<leader>qa', '<cmd>qa!<cr>', { desc = 'Quit All' })

-- disable subsitute
vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

-- Remap keypad numbers to regular numbers
for i = 0, 9 do
  vim.api.nvim_set_keymap('n', '<k' .. i .. '>', tostring(i), { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<k' .. i .. '>', tostring(i), { noremap = true, silent = true })
  vim.api.nvim_set_keymap('x', '<k' .. i .. '>', tostring(i), { noremap = true, silent = true })
  vim.api.nvim_set_keymap('o', '<k' .. i .. '>', tostring(i), { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<k' .. i .. '>', tostring(i), { noremap = true, silent = true })
end

-- vim.keymap.set({ "n" }, '<leader>gg', function() vim.cmd.TermOnClose("lazygit") end, { desc = "open lazygit" })
-- vim.keymap.set({ "n" }, '<leader>E', function() vim.cmd.TermOnClose("yazi") end, { desc = "open yazi" })
