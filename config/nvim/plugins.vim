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
Plug 'joshdick/onedark.vim'
Plug 'tomasiser/vim-code-dark'

" utilities
Plug '/home/jcostanzo/.fzf' | Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-ragtag'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
"Plug 'benekastah/neomake'
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-repeat'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'editorconfig/editorconfig-vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'sotte/presenting.vim', { 'for': 'markdown' }
Plug 'ervandew/supertab'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-sleuth'
Plug 'sickill/vim-pasta'
Plug 'marijnh/tern_for_vim', { 'for': ['javascript'], 'do': 'yarn install' }
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'tpope/vim-vinegar'
Plug 'pct/present.vim'
Plug 'tpope/vim-sleuth'
Plug 'mklabs/split-term.vim'
Plug 'w0rp/ale'
"Plug 'roxma/nvim-completion-manager'

" html / templates
Plug 'mattn/emmet-vim', { 'for': ['blade', 'html', 'javascript'] }
Plug 'gregsexton/MatchTag', { 'for': 'html' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'mustache/vim-mustache-handlebars'
Plug 'digitaltoad/vim-pug', { 'for': 'pug' }
Plug 'OrangeT/vim-csharp', { 'for': 'cshtml' }

" php
Plug 'jwalton512/vim-blade', { 'for': 'blade' }

" JavaScript
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'html'] }
Plug 'moll/vim-node', { 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': ['jsx', 'javascript'] }
Plug 'posva/vim-vue', { 'for': 'vue' }

" TypeScript
Plug 'jason0x43/vim-tss', { 'for': 'typescript', 'do': 'yarn install' }
Plug 'clausreinke/typescript-tools.vim', { 'for': 'typescript' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

" Styles
Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'ap/vim-css-color', { 'for': ['css','stylus','scss'] }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'junegunn/limelight.vim', { 'for': 'limelight' }
Plug 'bolasblack/csslint.vim'

" Markdown
Plug 'tpope/vim-markdown', { 'for': 'markdown' }

" Ember
Plug 'alexlafroscia/vim-ember-cli', { 'for': 'javascript' }

" General
Plug 'elzr/vim-json', { 'for': 'json' }

call plug#end()

