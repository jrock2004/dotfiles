local cmd = vim.cmd

local function augroups(autocmds, name)
  cmd('augroup ' .. name)
  cmd('autocmd!')
  for _, autocmd in ipairs(autocmds) do cmd('autocmd ' .. table.concat(autocmd, ' ')) end
  cmd('augroup END')
end

augroups({
  {
    'FileType', 'dashboard',
    'setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= '
  }, {'FileType', 'dashboard', 'set showtabline=0 | autocmd BufLeave <buffer> set showtabline=2'}
}, '_dashboard')
augroups({
  {'FileType', 'dashboard', 'nnoremap <silent> <buffer> q :q<CR>'},
  {'FileType', 'lspinfo', 'nnoremap <silent> <buffer> q :q<CR>'},
  {'FileType', 'floaterm', 'nnoremap <silent> <buffer> q :q<CR>'},
  {'FileType', 'help', 'nnoremap <silent> <buffer> q :bd<CR>'}
}, '_buffer_bindings')
augroups({
  {'BufWinEnter', '.template', 'setlocal filetype=apache'}, {'BufRead', '*.template', 'setlocal filetype=apache'},
  {'BufNewFile', '*.template', 'setlocal filetype=apache'}
}, '_template')
augroups({
  {'BufWinEnter', 'Dockerfile', 'setlocal filetype=dockerfile'},
  {'BufRead', 'Dockerfile*', 'setlocal filetype=dockerfile'}, {'BufNewFile', 'Dockerfile*', 'setlocal filetype=apache'}
}, '_dockerfile')
augroups({
  {'BufWinEnter', '.conf', 'setlocal filetype=dosini'}, {'BufRead', '*.conf', 'setlocal filetype=dosini'},
  {'BufNewFile', '*.conf', 'setlocal filetype=dosini'}
}, '_conf')
