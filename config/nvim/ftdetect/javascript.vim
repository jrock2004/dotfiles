setlocal textwidth=120

autocmd BufRead *.js.symlink set filetype=javascript
autocmd BufRead *.es6 set filetype=javascript

let g:neomake_javascript_enabled_markers = findfile('.jshintrc', '.;') != '' ? ['jshint'] : ['eslint']
