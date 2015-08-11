NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_extensions = ['tag', 'buffertag', 'line', 'funky']
", 'git-log', 'git_branch', 'git_files', 'modified']
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_map='<c-f>'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git|bower_components\'
let g:ctrlp_use_caching = 0

map <leader>t :CtrlP<CR>