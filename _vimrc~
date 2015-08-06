" General -----------------------
set nocompatible             " Makes vim better

scriptencoding utf-8         " Setting everything to UTF-8
set encoding=utf-8
set history=256
set timeoutlen=250
set clipboard+=unnamed
let g:autotagTagsFile = ".git/tags"
set tags=./.git/tags,tags,./.git/coffeetags,coffeetags;$HOME

set nobackup
set nowritebackup
set noswapfile

set hlsearch
set ignorecase
set smartcase
set incsearch

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

let mapleader = ','
let maplocalleader = '	'
let g:netrw_banner = 0


" Formatting --------------------
set nowrap

set tabstop=4
set softtabstop=4
set shiftwidth=4

set backspace=indent
set backspace+=eol
set backspace+=start

set autoindent
set cindent
set indentkeys-=0#
set cinkeys-=0#
set cinoptions=:s,ps,ts,cs
set cinwords=if,else,while,do
set cinwords+=for,switch,case

set linespace=4
set listchars=tab:>.,trail:.,extends:\#,nbsp:.
set list

" Visual ------------------------
syntax on

set showmatch

if has('gui_running')
	set guifont=InputMono:h16

	if has('mac')
	set noantialias
	endif
endif

set novisualbell
set noerrorbells
set vb t_vb=
set laststatus=2

" Airline Settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" Default
let g:airline#extensions#tmuxline#enabled = 0
" Presentation
"let g:airline#extensions#tmuxline#enabled = 1

" Ctrl-P settings
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_extensions = ['tag', 'buffertag', 'line', 'funky']
", 'git-log', 'git_branch', 'git_files', 'modified']
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'
map <leader>t :CtrlP getcwd()<CR>
map <leader>gs :CtrlPGitFiles<CR>
map <leader>gb :CtrlPGitBranch<CR>
map <leader>gl :CtrlPGitLog<CR>
map <leader>gm :CtrlPModified<CR>


" ctrlp-modified
map <Leader>m :CtrlPModified<CR>
map <Leader>M :CtrlPBranch<CR>

" Tagbar settings
map <F8> :TagbarToggle<CR>

" Emmet settings
imap <C-e> <C-y>,

" Multiple Cursor Settings
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_key='<leader>m'
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Git Gutter Settings
highlight clear SignColumn
map ]h <Plug>GitGutterNextHunk
map [h <Plug>GitGutterPrevHunk
map <leader>hv <Plug>GitGutterPreviewHunk
map <Leader>hs <Plug>GitGutterStageHunk
map <Leader>hr <Plug>GitGutterRevertHunk

" NERD Tree Settings
map <TAB> :NERDTreeToggle<CR>
map <leader>ff :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore=[]


" Plugins ------------------------
filetype off 

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'xero/sourcerer.vim'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'ap/vim-css-color'
Plugin 'groenewege/vim-less'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'kien/ctrlp.vim'
Plugin 'jasoncodes/ctrlp-modified.vim'
Plugin 'kaneshin/ctrlp-git-log'
Plugin 'jiangmiao/auto-pairs'
Plugin 'lokaltog/vim-easymotion'
Plugin 'majutsushi/tagbar'
Plugin 'mattn/ctrlp-git'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'mattn/emmet-vim'
Plugin 'mtscout6/rainbow_parentheses.vim'
Plugin 'mtscout6/vim-ctags-autotag'
Plugin 'mtscout6/vim-tagbar-css'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-surround'


call vundle#end() 
filetype plugin indent on

" Rainbow
map <leader>rt :RainbowParenthesesToggle<CR>
map <leader>r( :RainbowParenthesesLoadRound<CR>
map <leader>r[ :RainbowParenthesesLoadSquare<CR>
map <leader>r{ :RainbowParenthesesLoadBraces<CR>
map <leader>r< :RainbowParenthesesLoadChevrons<CR>

" File Type Settings --------------------

" Markdown editing
autocmd Filetype markdown setlocal wrap
autocmd Filetype markdown setlocal linebreak
autocmd Filetype markdown setlocal nolist
autocmd Filetype markdown setlocal columns=80
autocmd Filetype markdown setlocal tw=80
autocmd Filetype markdown setlocal wm=4


" GVIM
" GVIM Options -----------------------
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L
