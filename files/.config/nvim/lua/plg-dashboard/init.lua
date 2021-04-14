local g = vim.g

g.dashboard_default_executive = 'telescope'
g.dashboard_custom_section = {
  a = {description = {' Find File          '}, command = 'Telescope find_files'},
  b = {description = {' Recently Used Files'}, command = 'Telescope oldfiles'},
  c = {description = {' Load Last Session  '}, command = 'SessionLoad'},
  d = {description = {' Find Word          '}, command = 'Telescope live_grep'}
  -- e = {description = {' Settings           '}, command = ':e ~/.config/nvim/nv-settings.lua'}
  -- e = {description = {' Marks              '}, command = 'Telescope marks'}
}
