" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
  if executable('curl')
    let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
    if v:shell_error
      echom "Error downloading vim-plug. Please install it manually.\n"
      exit
    endif
  else
    echom "vim-plug not installed. Please install it manually or install curl.\n"
    exit
  endif
endif

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !python3 ./install.py --clang-completer --tern-completer --omnisharp-completer
  endif
endfunction

call plug#begin('~/.nvim/plugged')

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

" utilities
Plug '/home/jcostanzo/.fzf' | Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/committia.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'editorconfig/editorconfig-vim'
Plug 'sotte/presenting.vim', { 'for': 'markdown' }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'marijnh/tern_for_vim', { 'for': ['javascript'], 'do': 'yarn install' }
" Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-vinegar'
Plug 'yggdroot/indentline'
Plug 'kien/rainbow_parentheses.vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-projectionist'
Plug 'christoomey/vim-tmux-navigator'
Plug 'kassio/neoterm'
Plug 'roxma/nvim-completion-manager' "Watching for progress
Plug 'othree/csscomplete.vim'
Plug 'roxma/nvim-cm-tern',  {'do': 'yarn install'}
Plug 'BurningEther/nvimux'

" html / templates
Plug 'mattn/emmet-vim', { 'for': ['blade', 'html', 'javascript', 'html.handlebars'] }
Plug 'gregsexton/MatchTag', { 'for': 'html' }
Plug 'mustache/vim-mustache-handlebars', { 'for': 'html.handlebars'}

" CSS
Plug 'gko/vim-coloresque'

call plug#end()

