" Remap the Leader key
let mapleader = ','
let g:mapleader = ','

" General Stuff
set backspace=indent,eol,start
set clipboard=unnamedplus
set autoread
set showcmd
set showfulltag
set modeline
set modelines=5
set wildignore+=*/.git/*,*/.svn/*,*/.idea/*,*.DS_Store
set exrc
set secure
set showmode
set lazyredraw

" Default tabbing
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent

" Searching
set hlsearch
set ignorecase
set smartcase
set incsearch

" File Backup
set nobackup
set nowritebackup
set noswapfile

" Editor Stuff
set visualbell t_vb=
set noerrorbells
set novisualbell
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

" Tags
set tags=tags;/
