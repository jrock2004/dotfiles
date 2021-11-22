local components = require 'plugins.lualine.components'
local onedarker = require 'lualine.themes.onedarker'

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = onedarker,
    component_separators = {' ', ' '},
    section_separators = {' ', ' '},
    disabled_filetypes = { "dashboard" }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {components.diagnostics, components.diff, components.lsp, 'filetype'},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
