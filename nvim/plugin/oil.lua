require("oil").setup({})

vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<CR>", { desc = "Open oil" })
