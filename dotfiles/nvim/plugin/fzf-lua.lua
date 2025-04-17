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
      ["<C-l>"] = "toggle-preview",
    },
    fzf = {
      true,
      ["ctrl-q"] = "select-all+accept",
      ["ctrl-v"] = "toggle-preview",
    }
  },
})


local gitRoot = vim.fs.root(0, ".git")
local opts = { cwd = gitRoot }

vim.keymap.set({ 'n' }, "<leader>sf", function()
    fzf.files()
  end,
  { desc = "Fuzzy find files" })

vim.keymap.set({ 'n' }, "<leader>sF", function()
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

vim.keymap.set({ "n" }, "sS", function()
    fzf.lsp_live_workspace_symbols()
  end,
  { desc = "LSP references" })


vim.keymap.set({ "n" }, "ss", function()
    fzf.lsp_document_symbols()
  end,
  { desc = "LSP references" })
