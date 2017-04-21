let g:neomake_css_csslint_maker = {
			\ 'args': ['--verbose'],
			\ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
			\ }

let g:neomake_css_enabled_markers = ['csslint']

" Code Folding
setlocal foldmethod=marker
setlocal foldmarker={,}
setlocal foldlevel=99
