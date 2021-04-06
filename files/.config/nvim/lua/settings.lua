local o = vim.o -- get/set options
local wo = vim.wo -- window local options
local bo = vim.bo -- buffer local options
-- local g = vim.g -- global variables
local cmd = vim.cmd -- ex commands

-- get/set options
o.dir = '/tmp'
o.smartcase = true
o.laststatus = 2
o.incsearch = true
o.ignorecase = true
o.scrolloff = 8
o.timeoutlen = 3000
o.ttimeoutlen = 100
o.mouse = 'a'
o.wildmenu = true
o.showmode = false
o.listchars = 'eol:¬,tab:>·,extends:>,precedes:<,space:·'
o.hidden = true
o.background = 'dark'
o.syntax = 'on'
o.backspace = 'indent,eol,start'
o.clipboard = 'unnamedplus'
o.autoread = true
o.inccommand = 'nosplit'
o.cmdheight = 2
o.encoding = 'utf-8'
o.termguicolors = true
o.t_Co = '256'
o.backup = false
o.writebackup = false
o.pumheight = 2
o.splitbelow = true
o.splitright = true
o.showtabline = 2 -- Always show tabs
o.updatetime = 50
-- o.shiftwidth = 2
-- o.softtabstop = 2
-- o.tabstop = 2
o.autoindent = false

-- buffer local options
bo.swapfile = false
-- bo.expandtab = true
bo.smartindent = true
-- bo.shiftwidth = 2
-- bo.softtabstop = 2
-- bo.tabstop = 2

-- window local options
wo.cursorline = true
wo.foldenable = false
wo.linebreak = false
wo.relativenumber = true
wo.signcolumn = 'yes'
wo.number = true
wo.list = true

-- global variables

-- ex commands
cmd 'colorscheme nvcode' -- setting theme
cmd 'set colorcolumn=99999' -- help to fix indentation
cmd 'set iskeyword+=-' -- make it so - is part of the work
cmd 'set shortmess+=c' -- don't pass messages to |ins-completion-menu|.
cmd 'set tabstop=2' -- insert 2 spaces
cmd 'set shiftwidth=2'
cmd 'set expandtab'
-- cmd 'set softtabstop=2'

