local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function(use)
  -- packer will manage itself
  use 'wbthomason/packer.nvim'

  -- colors
  use 'christianchiarulli/nvcode-color-schemes.vim'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'norcalli/nvim-colorizer.lua'

  -- file explorer
  use 'kyazdani42/nvim-tree.lua'

  -- terminal
  use 'voldikss/vim-floaterm'

  -- icons
  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'

  -- status line and buffer
  use 'glepnir/galaxyline.nvim'
  use 'romgrk/barbar.nvim'

  -- autocomplete
  use 'hrsh7th/nvim-compe'
  use 'mattn/emmet-vim'
  use 'hrsh7th/vim-vsnip'

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'

  -- telescope
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-media-files.nvim'

  -- git
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

  -- intellisense
  use 'glepnir/lspsaga.nvim'
  use 'onsails/lspkind-nvim'
  use {'RishabhRD/nvim-lsputils', requires = {'RishabhRD/popfix'}}

  -- general
  use 'terrortylor/nvim-comment'
  use 'tpope/vim-surround'

  -- dashboard
  use 'ChristianChiarulli/dashboard-nvim'
end)
