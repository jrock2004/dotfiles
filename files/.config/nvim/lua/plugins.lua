local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = Lvim.packerInstallPath

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function(use)
  -- packer will manage itself
  use 'wbthomason/packer.nvim'

  -- colors
  use 'LunarVim/onedarker.nvim'
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
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  -- autocomplete
  use 'hrsh7th/nvim-compe'
  use 'mattn/emmet-vim'
  use {'hrsh7th/vim-vsnip', requires = {'rafamadriz/friendly-snippets'}}
  use 'hrsh7th/vim-vsnip-integ'
  use 'windwp/nvim-autopairs'

  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'kabouzeid/nvim-lspinstall'
  use {'jose-elias-alvarez/null-ls.nvim', requires = {{'nvim-lua/plenary.nvim'},
  {'neovim/nvim-lspconfig'}}}

  -- telescope
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope-fzy-native.nvim'}}}

  -- git
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

  -- general
  use 'numToStr/Comment.nvim'
  use 'folke/trouble.nvim'
end)
