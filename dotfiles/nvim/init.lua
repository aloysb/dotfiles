-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

require("lsp")
require("opts")
require("autocmds")
require("sh")
require("keymaps")
require("term")

-- colorscheme
require('onenord').setup({
  custom_colors = {
    highlight = "#B48EAD"
  }
})

-- Testing tree sitter
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
}
