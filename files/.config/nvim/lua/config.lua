local set = require('lua-helpers.command').set

-- get/set options
set('dir', '/tmp')
set 'smartcase'
set('laststatus', 2)
set 'incsearch'
set 'ignorecase'
set('scrolloff', 8)
set('timeoutlen', 3000)
set('ttimeoutlen', 100)
set('mouse', 'a')
set 'wildmenu'
set('showmode', false)
set('listchars', 'eol:¬,tab:>·,extends:>,precedes:<,space:·')
set 'hidden'
set('background', 'dark')
set('backspace', 'indent,eol,start')
set('clipboard', 'unnamedplus')
set 'autoread'
set('inccommand', 'nosplit')
set('cmdheight', 2)
set('encoding', 'utf-8')
set 'termguicolors'
set('t_Co', '256')
set('backup', false)
set('writebackup', false)
set('pumheight', 4)
set 'splitbelow'
set 'splitright'
set('showtabline', 2)
set('updatetime', 50)
set('autoindent', false)
set('swapfile', false)
set 'smartindent'
set 'cursorline'
set('foldenable', false)
set('linebreak', false)
set 'relativenumber'
set('signcolumn', 'yes')
set 'number'
set 'list'
set('tabstop', 2)
set('shiftwidth', 2)
set 'expandtab'

-- colors
vim.cmd('syntax on')
vim.g.nvcode_termcolors = 256
vim.cmd('colorscheme nvcode')
set('colorcolumn', 99999)
vim.cmd('set iskeyword+=-')
vim.cmd('set shortmess+=c')
