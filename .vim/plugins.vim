filetype off
filetype plugin indent off

"if has('vim_starting')
	set nocompatible
	set runtimepath+=~/.vim/bundle/neobundle.vim/
	set runtimepath+=~/.vim/plugins/
"endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'xero/sourcerer.vim'

"""runtime! plugins/*.vim

for fpath in split(globpath('~/.vim/plugins/', '*.vim'), '\n') 
	exe 'source' fpath 
endfor 



call neobundle#end()

filetype plugin indent on
syntax on

NeoBundleCheck