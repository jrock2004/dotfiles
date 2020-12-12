" True Colors (tm)
set termguicolors

"""""""""""""""""""""""""
" UI / Aesthetics
"""""""""""""""""""""""""
set background=dark
let ayucolor="dark"
colorscheme ayu
" let g:SnazzyTransparent=1
" colorscheme snazzy

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

"""""""""""""""""""""""""
" Editor
"""""""""""""""""""""""""
syntax on
set encoding=utf-8

set cmdheight=1

set mouse=a
set noshowmode
set laststatus=2

set number
set relativenumber

set backspace=indent,eol,start
set clipboard^=unnamedplus,unnamed

set autoindent

" Default indentation - editorconfig should override these
set tabstop=2
set shiftwidth=2
set expandtab
set linebreak
set showbreak=…

set hlsearch
set list

set listchars=eol:¬,tab:>·,extends:>,precedes:<,space:·

set autoread

set scrolloff=8

set history=1000

set hidden

" Search
set ignorecase
set smartcase
set incsearch
set inccommand=nosplit

set viminfo='100,n$HOME/.vim/files/info/viminfo

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

set updatetime=50

set shortmess+=c

""""""""""""""""""""
" Code Management
""""""""""""""""""""
set foldmethod=indent
set foldlevel=99
set nofoldenable
set signcolumn=yes
