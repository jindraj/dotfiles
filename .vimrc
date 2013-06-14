set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/powerline'
Bundle 'scrooloose/nerdtree'

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
let g:Powerline_symbols = 'fancy'
filetype plugin indent on     " required!
" BASIC SETTINGS
"""""""""""""""""""
set background=dark		" Change colors to more usable on black background
set enc=utf-8			" Set encoding to UTF-8. Needed by 'vim-powerline'
set termencoding=utf-8			" Set encoding to UTF-8. Needed by 'vim-powerline'
set laststatus=2		" To see powerline everytime (not only in split windows). Needed by 'vim-powerline'
set nocompatible		" I want to use vim, not vi. Be iMproved. Needed by 'vim-powerline'
set novisualbell		" Disable window blinking
set ruler			" Shows ruler in the bottom (not needed if 'vim-powerline is on'
set scrolloff=5			" Preserve 5 visible lines up/down when moving vertical
set shortmess=I			" Hide splash screen :)
set showmatch			" Show matching bracets whern text indicator is over them
set sidescrolloff=10		" Preserve at least 10 columns on both sides of cursor?
set wildignore=*.dll,*.o,*.obj,*.bak,*.exe,*.pyc,*.jpg,*.gif,*.png
set wildmenu			" Set command completion
set wildmode=list:longest
set t_Co=256			" Enable 256-color mode
set modeline        		" Last lines in document sets vim mode
set modelines=3     		" Number lines checked for modelines
set undolevels=200		" Number of possible undo actions

" SEARCHING
"""""""""""""""""""
set hlsearch			" Highlight every presence of search prhrase
set incsearch			" Highlight search phrase on the fly
set ignorecase			" Case insensitive search

" LINE NUMBERS
"""""""""""""""""""
set number			" Display line numbers on the left
set numberwidth=5 		" Fix width for 5 digits number

hi LineNr ctermfg=darkgrey cterm=bold ctermbg=0

" TABS & IDNENTS
"""""""""""""""""""
set noexpandtab			" Don't expand TABs into SPACEs

set matchtime=5			" 

syntax enable			" enable syntax highliting

filetype plugin indent on	" enable filetype, plugin and language-dependent indenting 

" Tab key shortcuts configuraion
let mapleader=","
map <leader>tc :tabnew! %<cr>
map <leader>tn :tabnext
map <leader>tp :tabprev
map <leader>te :tabedit
map <leader>tq :tabclose<cr>
map <leader>tm :tabmove
