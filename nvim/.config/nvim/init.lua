-- remap leader key to space
vim.g.mapleader = " "
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Manually fix floating window background color
vim.api.nvim_set_hl(0, 'FloatBorder', {bg='#3B4252', fg='#5E81AC'})
vim.api.nvim_set_hl(0, 'NormalFloat', {bg='#3B4252'})
vim.api.nvim_set_hl(0, 'TelescopeNormal', {bg='#3B4252'})
vim.api.nvim_set_hl(0, 'TelescopeBorder', {bg='#3B4252'})

-- Text Formatting
vim.cmd("syntax on") -- Enable syntax highlighting
vim.cmd("filetype on") -- Enable filetype detection
vim.cmd("filetype indent on")
vim.cmd("filetype plugin on")

vim.o.autoindent=true -- Copy indent from previous line
vim.o.expandtab=true -- Use soft tabs
vim.o.tabstop=4 -- Number of spaces for Tab
vim.o.softtabstop=4 -- Number of spaces when editing with Tab or BS
vim.o.shiftwidth=4 -- Number of spaces for each (auto)indent step
vim.o.textwidth=99 -- Maximum width to break line at
vim.opt.wrap=false -- Do not wrap lines longer than screen size
-- vim.o.backspace=indent,eol,start -- Allow backspacing on everything in insert mode
vim.o.number=true -- Show line number when printing
vim.o.ruler=true -- Show the cursor position for all windows
vim.o.showcmd=true -- Display incomplete commands
vim.o.showmatch=true -- Highlight matching braces
vim.o.errorbells=false -- Do not ring bell for error messages
vim.o.visualbell=true -- Use visual bell instead of beeping
-- vim.o.guioptions-=r -- Remove right-hand scrollbar
-- vim.o.guioptions-=R -- Remove right-hand scrollbar for vsplit
-- vim.o.guioptions-=l -- Remove left-hand scrollbar
-- vim.o.guioptions-=L -- Remove left-hand scrollbar for vsplit
-- vim.o.guioptions-=b -- Remove bottom scrollbar

-- Searching
--set ignorecase -- Ignore case when searching
vim.o.hlsearch=true -- Switch on search pattern highlighting.
vim.o.history=50 -- Keep 50 lines of command line history
vim.o.incsearch=true -- Search as you type

-- set colorcolumn=80
-- highlight ColorColumn ctermbg=magenta
-- call matchadd('ColorColumn', '\%100v', 100)

-- Lazy plugin manager
require("config.lazy")
require("config.nvim-tree")
require("config.gitsigns")
require("config.telescope")
require("config.which-key")
