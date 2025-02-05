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


-- set neovim to transparent
vim.cmd [[
highlight Normal guibg=none
highlight NonText guibg=none
highlight Normal ctermbg=none
highlight NonText ctermbg=none
]]

-- colorscheme
vim.cmd('colorscheme nord')
