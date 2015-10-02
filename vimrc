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

set tabstop=4
set shiftwidth=4
set shiftround

set list listchars=tab:»·,trail:·,nbsp:·

set textwidth=80
set colorcolumn=+1

set number

set splitbelow
set splitright

set matchpairs+=<:>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Load up all of our plugins
if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

filetype plugin indent on

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

if has("gui_running")
	set guifont=InputMono:h14:cANSI
	set lines=30 columns=85
	set guioptions-=m
	set guioptions-=T
	set guioptions-=r
endif
