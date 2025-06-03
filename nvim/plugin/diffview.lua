vim.keymap.set('n', '<leader>gfh', ':DiffviewFileHistory %<CR>', { desc = "Git file history" })
vim.keymap.set('v', '<leader>gfh', ":'<,'>DiffviewFileHistory<CR>", { desc = "Git selection history" })
vim.keymap.set('n', '<leader>gD', ":DiffviewOpen<CR>", { desc = "Git diff view" })


local diffview_group = vim.api.nvim_create_augroup("DiffviewGroup", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  group = diffview_group,
  pattern = "diffview://*",
  callback = function()
    vim.keymap.set('n', '<leader>q', ':DiffviewClose<CR>', { desc = "Close Diffview", buffer = true })
  end,
})
