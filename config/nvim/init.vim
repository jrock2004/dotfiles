call plug#begin('~/.nvim/plugged')

" colorschemes
Plug 'flazz/vim-colorschemes'

" utilities
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'bling/vim-airline'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'garbas/vim-snipmate'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'editorconfig/editorconfig-vim'

" language specific
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'

call plug#end()

" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
set autoread

set backspace=indent,eol,start

let mapleader = ','
let g:mapleader = ','

set history=1000 " change history to 1000
set textwidth=120

set noexpandtab " insert tabs rather than spaces for <Tab>
set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=4 " the visible width of tabs
set softtabstop=4 " edit as if the tabs are 4 characters wide
set shiftwidth=4 " number of spaces to use for indent and unindent
set shiftround " round indent to a multiple of 'shiftwidth'
set completeopt+=longest

set clipboard=unnamed

" faster redrawing
set ttyfast

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

if has('autocmd') && !exists('autocommands_loaded')
	let autocommands_loaded = 1

    " automatically resize panes on resize
    autocmd VimResized * exe 'normal! \<c-w>='
    autocmd BufWritePost .vimrc source %
    autocmd BufWritePost .vimrc.local source %
    " save all files on focus lost, ignoring warnings about untitled buffers
    autocmd FocusLost * silent! wa

    autocmd BufNewFile,BufRead *.ejs set filetype=html

    " make quickfix windows take all the lower section of the screen when there
    " are multiple windows open
    autocmd FileType qf wincmd J

    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    let g:markdown_fenced_languages = ['css', 'javascript', 'js=javascript', 'json=javascript', 'stylus', 'html']

    " autocmd! BufEnter * call ApplyLocalSettings(expand('<afile>:p:h'))

    autocmd! BufWritePost * Neomake
endif

" code folding settings
set foldmethod=syntax " fold based on indent
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " don't fold by default
set foldlevel=1

" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set so=7 " set 7 lines to the cursors - when moving vertical
set wildmenu " enhanced command line completion
set hidden " current buffer can be put into background
set showcmd " show incomplete commands
set noshowmode " don't show which mode disabled for PowerLine
set wildmode=list:longest " complete files like a shell
set scrolloff=3 " lines of text around cursor
set shell=$SHELL
set cmdheight=1 " command bar height

set title " set terminal title

" Searching
set ignorecase " case insensitive searching
set smartcase " case-sensitive if expresson contains a capital letter
set hlsearch
set incsearch " set incremental search, like modern browsers
set nolazyredraw " don't redraw while executing macros

set magic " Set magic on, for regex

set showmatch " show matching braces
set mat=2 " how many tenths of a second to blink

" error bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Add margins
set colorcolumn=81

" Dynamic line numbers
set rnu
function! ToggleNumbersOn()
	set nu!
	set rnu
endfunction
function! ToggleRelativeOn()
	set rnu!
	set nu
endfunction
autocmd FocusLost * call ToggleRelativeOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleRelativeOn()

" switch syntax highlighting on
syntax on

set encoding=utf8

set t_Co=256

set background=dark
colorscheme gruvbox

set number " show the current line number"

set wrap "turn on line wrapping
set wrapmargin=8 " wrap lines when coming within n characters from side
set linebreak " set soft wrapping
set showbreak=… " show ellipsis at breaking

set autoindent " automatically set indent of new line
set smartindent

" => Files, backups, and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nobackup
set nowritebackup
set noswapfile

" => StatusLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set laststatus=2 " show the satus line all the time

" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" shortcut to save
nmap <leader>, :w<cr>

" disable Ex mode
noremap Q <NOP>

" set paste toggle
set pastetoggle=<F6>

" toggle paste mode
map <leader>v :set paste!<cr>

" clear highlighted search
noremap <space> :set hlsearch! hlsearch?<cr>

" toggle invisible characters
set invlist
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
highlight SpecialKey ctermbg=none " make the highlighting of tabs less annoying
set showbreak=↪
nmap <leader>l :set list!<cr>

map <silent> <C-h> :call WinMove('h')<cr>
map <silent> <C-j> :call WinMove('j')<cr>
map <silent> <C-k> :call WinMove('k')<cr>
map <silent> <C-l> :call WinMove('l')<cr>

map <leader>wc :wincmd q<cr>

" toggle cursor line
nnoremap <leader>i :set cursorline!<cr>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" helpers for dealing with other people's code
nmap \t :set ts=4 sts=4 sw=4 noet<cr>
nmap \s :set ts=4 sts=4 sw=4 et<cr>

" always use vertical diffs
set diffopt+=vertical

" Using the Silver Searcher
if executable('ag')
	" Use Ag over Grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden
		\ --ignore=".git" --ignore="public" --ignore="node_modules"
		\ --ignore="bower_components" -g ""'

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""" CtrlP
nmap <silent> <leader>r :CtrlPBuffer<cr>
let g:ctrlp_map='<leader>t'
let g:ctrlp_dotfiles=1
let g:ctrlp_working_path_mode = 'ra'

""""" Fugitive
nmap <silent> <leader>gs :Gstatus<cr>
nmap <leader>ge :Gedit<cr>
nmap <silent><leader>gr :Gread<cr>
nmap <silent><leader>gb :Gblame<cr>
nmap <silent><leader>gc :Gcommit<cr>
nmap <leader>m :MarkedOpen!<cr>
nmap <leader>mq :MarkedQuit<cr>

""""" NeoMake
let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
\ }
let g:neomake_javascript_enabled_markers = ['jshint', 'jscs']

""""" Airline
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='dark'

""""" netrw
let g:netrw_localrmdir='rm -r'

" Mapping keys
"""""""""""""""""""""""""""""""""
nmap <Leader>gp :Dispatch git push origin master<cr>
nnoremap <up> :echo "Stop being stupid"<cr>
nnoremap <down> :echo "Stop being stupid"<cr>
nnoremap <left> :echo "Stop being stupid"<cr>
nnoremap <right> :echo "Stop being stupid"<cr>
