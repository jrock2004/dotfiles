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
  use 'norcalli/nvim-colorizer.lua'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

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
  use 'hrsh7th/vim-vsnip-integ'

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'
  use 'RishabhRD/nvim-lsputils'
  use 'RishabhRD/popfix'

  -- telescope
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}

  -- git
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

  -- intellisense
  use 'onsails/lspkind-nvim'

  -- general
  use 'terrortylor/nvim-comment'
  use 'tpope/vim-surround'

  -- dashboard
  use 'ChristianChiarulli/dashboard-nvim'
end)
