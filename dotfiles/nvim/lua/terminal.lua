termGroup = vim.apu.nvim_create_augroup("TermOnClose", {})

vim.api.nvim_create_user_command("TermOnClose", function(opts)
  local current_buf = vim.api.nvim_get_current_buf()
  cmd = opts.args
  print(cmd)
  vim.cmd("terminal " .. cmd)
  vim.cmd('startinsert')
  vim.api.nvim_create_autocmd('TermClose', {
    pattern = "term://",
    callback = function()
      local term_buf = vim.api.nvim_get_current_buf()
      if term_buf ~= current_buf then
        vim.api.nvim_set_current_buf(current_buf)
      end
    end
  })
end, { nargs = "+", group = "termGroup" })

vim.keymap.set({ "n" }, '<leader>gg', function() vim.cmd.TermOnClose("lazygit") end, { desc = "open lazygit" })
vim.keymap.set({ "n" }, '<leader>ty', function() vim.cmd.TermOnClose("yazi") end, { desc = "open yazi" })
