-- Initial file for loading my Neovim configuration

require('default-config')

-- Setting leader as its not most important
vim.g.mapleader = Lvim.leader
vim.g.maplocalleader = Lvim.leader

require('mappings')
require('plugins')
require('settings')

local pluginList = {
  "autopairs",
  "colorize",
  "comment",
  "compe",
  "emmet",
  "floatterm",
  "gitsigns",
  "lualine/lualine",
  "nvimtree",
  "telescope",
  "treesitter",
  "trouble",
  "vsnip",
}

-- Loop through list of plugins and require them
for _, plugin in ipairs(pluginList) do
  require('plugins/' .. plugin)
end

require('nullls')
