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
vim.cmd('colorscheme nordfox')

-- set neovim to transparent
vim.cmd [[
 highlight Normal guibg=none
 highlight Normal ctermbg=none
 highlight NormalNC guibg=none
 highlight NormalNC ctermbg=none
 highlight EndOfBuffer guibg=none
 highlight EndOfBuffer ctermbg=none
 highlight NonText guibg=none
 highlight NonText ctermbg=none
]]

-- Testing tree sitter
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
}
