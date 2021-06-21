-- Setting leader as its not most important
vim.g.mapleader = ','
vim.g.maplocalleader = ','

require('mappings')
require('plugins')
require('config')

-- plugin settings
require('plugins/nvimtree')
require('plugins/floatterm')
require('plugins/galaxyline')
require('plugins/barber')
require('plugins/compe')
require('plugins/telescope')
require('plugins/gitsigns')
require('plugins/lspkind')
require('plugins/comment')
require('plugins/dashboard')
require('plugins/emmet')
require('plugins/colorize')
require('plugins/treesitter')

require('lsp-config')
