require('default-config')

-- Setting leader as its not most important
vim.g.mapleader = Lvim.leader
vim.g.maplocalleader = Lvim.leader

require('mappings')
require('plugins')
require('settings')

local pluginList = {
  "nvimtree",
  "floatterm",
  "lualine/lualine",
  "barber",
  "compe",
  "telescope",
  "gitsigns",
  "lspkind",
  "comment",
  "dashboard",
  "emmet",
  "colorize",
  "treesitter",
  "autopairs",
  "trouble",
  "vsnip",
  "refactoring"
}

-- Loop through list of plugins and require them
for _, plugin in ipairs(pluginList) do
  require('plugins/' .. plugin)
end

require('lsp-config')
