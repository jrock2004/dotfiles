call plug#begin('~/.config/nvim/plugged')

  """""""""""""""""
  " Syntax / Theme
  """""""""""""""""
  Plug 'morhetz/gruvbox'
  Plug 'joshdick/onedark.vim'
  Plug 'chriskempson/base16-vim'
  Plug 'ayu-theme/ayu-vim'

  """""""""""""""""
  " Editor
  """""""""""""""""
  " File / Project Finding
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'

  let g:fzf_layout = { 'down': '~25%' }

  Plug 'tpope/vim-vinegar'

  " Working with code
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'

  Plug 'editorconfig/editorconfig-vim'

  Plug 'sickill/vim-pasta'
  Plug 'ryanoasis/vim-devicons'

  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'

  Plug 'tpope/vim-projectionist'

  """"""""""""""""""""
  " Language Servers
  "
  " Debugging:
  "   node -e 'console.log(path.join(os.tmpdir(), "coc-nvim.log"))'
  """"""""""""""""""""
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }

  """"""""""""""""""
  " Status
  """"""""""""""""""
  Plug 'itchyny/lightline.vim'
  Plug 'mike-hearn/base16-vim-lightline'
  Plug 'joshdick/onedark.vim'

  let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \           [ 'gitbranch' ],
    \           [ 'readonly', 'filetype', 'filename' ]],
    \   'right': [ [ 'percent' ], [ 'lineinfo' ],
    \            [ 'fileformat', 'fileencoding' ],
    \            [ 'gitblame',
    \              'currentfunction',
    \              'cocstatus',
    \              'linter_errors',
    \              'linter_warnings'
    \            ]]
    \ },
    \ 'component_expand': {
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error'
    \ },
    \ 'component_function': {
    \   'fileencoding': 'LightlineFileEncoding',
    \   'filename': 'LightlineFileName',
    \   'fileformat': 'LightlineFileFormat',
    \   'filetype': 'LightlineFileType',
    \   'gitbranch': 'LightlineGitBranch',
    \   'cocstatus': 'coc#status',
    \   'currentfunction': 'CoCCurrentFunction',
    \   'gitblame': 'CocGitBlame'
    \ },
    \ 'tabline': {
    \   'left': [ [ 'tabs' ] ],
    \   'right': [ [ 'close' ] ]
    \ },
    \ 'tab': {
    \   'active': [ 'filename', 'modified' ],
    \   'inactive': [ 'filename', 'modified' ],
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
  \ }

  """"""""""""""""""
  " Syntax support
  """"""""""""""""""
  " html / templates
  Plug 'mattn/emmet-vim'

  " CSS
  Plug 'stephenway/postcss.vim'

  " Typescript syntax
  Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }

  " JavaScript Syntax
  Plug 'pangloss/vim-javascript'
  let g:javascript_plugin_jsdoc = 1
  Plug 'faceleg/vim-jsdoc'
  let g:jsdoc_enable_es6 = 1
  let g:jsdoc_allow_input_prompt = 1
  let g:jsdoc_input_description = 1

  " Ember template highlighting
  Plug 'joukevandermaas/vim-ember-hbs'

  " Nested syntax highlighting
  Plug 'Quramy/vim-js-pretty-template'

  " Syntax highlighting for fish
  Plug 'dag/vim-fish'

  """"""""""""""""""
  " Startup
  """"""""""""""""""
  Plug 'mhinz/vim-startify'

  let g:startify_files_number = 5
  let g:startify_change_to_dir = 0
  let g:startify_custom_header = [ ]
  let g:startify_relative_path = 1
  let g:startify_use_env = 1

  function! s:list_commits()
    let git = 'git -C ' . getcwd()
    let commits = systemlist(git . ' log --oneline | head -n5')
    let git = 'G' . git[1:]

    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
  endfunction

  let g:startify_lists = [
    \  { 'type': 'dir', 'header': [ 'Files '. getcwd() ] },
    \  { 'type': function('s:list_commits'), 'header': [ 'Recent Commits' ] },
    \  { 'type': 'sessions',  'header': [ 'Sessions' ]		 },
    \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]		 },
    \  { 'type': 'commands',  'header': [ 'Commands' ]		 },
  \ ]

  let g:startify_commands = [
    \ { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
    \ { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
    \ { 'uc': [ 'Update Coc Plugins', ':CocUpdate' ] },
  \ ]

  """"""""""""""""""
  " Snippets
  """"""""""""""""""
  Plug 'SirVer/ultisnips'

  " Ember"
  Plug 'josemarluedke/ember-vim-snippets'

  """"""""""""""""""
  " Uncategoried
  """"""""""""""""""
  Plug 'tpope/vim-repeat'

call plug#end()
