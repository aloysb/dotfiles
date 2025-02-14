local fzf = require('fzf-lua')

fzf.setup({
  winopts = {
    fullscreen = true,
    preview = {
      hidden = true
    }
  },
  keymap = {
    builtin = {
      ["<C-p>"] = "toggle-preview",
    },
    fzf = {
      true,
      ["ctrl-q"] = "select-all+accept",
      ["ctrl-p"] = "toggle-preview",
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
    fzf.live_grep()
  end,
  { desc = "Grep codebase from cwd" })

vim.keymap.set({ 'n' }, "<leader>sG", function()
    fzf.live_grep(opts)
  end,
  { desc = "Grep entire codebase" })


vim.keymap.set({ 'n' }, "<leader>so", function()
    fzf.oldfiles(opts)
  end,
  { desc = "Grep codebase" })


vim.keymap.set({ 'n' }, "<leader>sk", function()
    fzf.keymaps()
  end,
  { desc = "Search keymaps" })

vim.keymap.set({ 'n' }, "gra", function()
    fzf.lsp_code_actions({
      winopts = { fullscreen = false, height = 0.20, width = 0.33, relative = "cursor" }
    }
    )
  end,
  { desc = "Code actions" })

vim.keymap.set({ "n" }, "gd", function()
    fzf.lsp_definitions()
  end,
  { desc = "LSP definitions" })

vim.keymap.set({ "n" }, "grr", function()
    fzf.lsp_references()
  end,
  { desc = "LSP references" })
