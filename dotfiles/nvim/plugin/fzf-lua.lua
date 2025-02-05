local fzf = require('fzf-lua')

fzf.setup({
  winopts = {
    fullscreen = true,
    preview = {
      hidden = true
    }
  }
})


local gitRoot = vim.fs.root(0, ".git")
local opts = { cwd = gitRoot }

vim.keymap.set({ 'n' }, "<leader>sf", function()
    fzf.files(opts)
  end,
  { desc = "Fuzzy find files" })

vim.keymap.set({ 'n' }, "<leader>sg", function()
    fzf.live_grep(opts)
  end,
  { desc = "Grep codebase" })


vim.keymap.set({ 'n' }, "<leader>so", function()
    fzf.oldfiles(opts)
  end,
  { desc = "Grep codebase" })
