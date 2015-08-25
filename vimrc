set nocompatible

let mapleader = ","

set backspace=2
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler
set showcmd
set incsearch
set laststatus=2
set autoread

set ignorecase
set smartcase

set tabstop=2
set shiftwidth=2
set shiftround

set list listchars=tab:»·,trail:·,nbsp:·

set textwidth=80
set colorcolumn=+1

"set number

set splitbelow
set splitright

set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

set matchpairs+=<:>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

"if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
"  syntax on
"	set t_Co=256
"	set background=dark
"endif

" Load up all of our plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on
