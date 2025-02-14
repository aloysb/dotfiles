-- [[ Basic Autocommands ]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


local termGroup = vim.api.nvim_create_augroup("TermOnClose", { clear = true })

vim.api.nvim_create_user_command("TermOnClose", function(opts)
  local current_buf = vim.api.nvim_get_current_buf()
  local cmd = opts.args

  -- Open terminal and run the command
  vim.cmd("terminal " .. cmd)
  vim.cmd("startinsert")

  -- Create an autocommand to switch back to the previous buffer on TermClose
  vim.api.nvim_create_autocmd("TermClose", {
    group = termGroup,
    pattern = "term://*",
    callback = function()
      -- Ensure the buffer exists before switching
      if vim.api.nvim_buf_is_valid(current_buf) then
        vim.api.nvim_set_current_buf(current_buf)
      end
    end,
    once = true, -- Ensures it only triggers once per terminal instance
  })
end, { nargs = "+" })
