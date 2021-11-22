require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',
  ignore_install = {'haskell'},
  highlight = {
    enable = true
  },
  indent = {enable = true, disable = {'python'}},
  autotag = {enable = true},
}

vim.cmd('set foldmethod=expr')
vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
vim.cmd('set foldlevelstart=99')
vim.cmd('set foldnestmax=10')
vim.cmd('set foldlevel=1')

vim.opt.foldenable = false
