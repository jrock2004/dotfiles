local g = vim.g
local cmd = vim.cmd

g.dashboard_default_executive = 'telescope'
g.dashboard_custom_section = {
  a = {description = {' Find File          '}, command = 'Telescope find_files hidden=true'},
  b = {description = {' Recently Used Files'}, command = 'Telescope oldfiles hidden=true'},
  c = {description = {' Load Last Session  '}, command = 'SessionLoad'},
  d = {description = {' Find Word          '}, command = 'Telescope live_grep'}
  -- e = {description = {' Settings           '}, command = ':e ~/.config/nvim/nv-settings.lua'}
  -- e = {description = {' Marks              '}, command = 'Telescope marks'}
}

cmd('autocmd FileType dashboard set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2')
