-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
local o = vim.opt

o.number = true
o.relativenumber = true
o.mouse = 'a'
o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
o.clipboard = 'unnamedplus'

-- Enable break indent
o.breakindent = true

-- Wrap line at breakat
o.linebreak = true

-- make indent smart
o.smartindent = true
o.autoindent = true

o.pumblend = 10 -- Make builtin completion menus slightly transparent

-- Save undo history
o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
o.ignorecase = true
o.smartcase = true

-- Keep signcolumn on by default
o.signcolumn = 'yes'

-- Decrease update time
o.updatetime = 1000

-- Decrease mapped sequence wait time
o.timeoutlen = 1000

-- Configure how new splits should be opened
o.splitright = true
o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '·' }

-- Preview substitutions live, as you type!
o.inccommand = 'split'

-- Show which line your cursor is on
o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
o.scrolloff = 10

-- Disable netrwPlugin
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrw = 1

-- Tabs
o.tabstop = 2
o.softtabstop = 0
o.shiftwidth = 2
o.expandtab = true

-- highlight search
o.hlsearch = true

-- Border light
o.winborder = "rounded"
