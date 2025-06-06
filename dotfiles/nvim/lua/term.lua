local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

function create_floating_window(opts)
  local width = 80;
  local height = vim.o.lines - 2
  local row = 1
  local col = math.floor(vim.o.columns - width)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { win = win, buf = buf }
end

function toggle_terminal()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Close terminal" })
vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "Open floating terminal" })
