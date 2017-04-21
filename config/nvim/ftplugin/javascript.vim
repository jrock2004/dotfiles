let g:javascript_plugin_jsdoc = 1

let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
\ }

let g:neomake_javascript_enabled_markers = findfile('.jshintrc', '.;') != '' ? ['jshint'] : ['eslint']
