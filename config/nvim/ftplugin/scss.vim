let g:neomake_scss_csslint_maker = {
			\ 'args': ['--verbose'],
			\ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
			\ }

let g:neomake_scss_enabled_markers = ['csslint']
