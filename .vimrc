" settings basic {{{
set nocompatible               " be iMproved, needed by a lot of plugins
set shortmess=I			" Hide splash screen :)
filetype off                   " required!
" }}}

" Vundle configuration {{{
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle 2>/dev/null
    let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
"Add your bundles here
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
"Plugin 'Lokaltog/powerline'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/twilight256.vim'
Plugin 'vim-scripts/Puppet-Syntax-Highlighting'
Plugin 'tpope/vim-vividchalk'
Plugin 'tex.vim'
Plugin 'gitvimdiff'
Plugin 'ldap_schema.vim'
Plugin 'muttrc.vim'
Plugin 'ldif.vim'
Plugin 'haproxy'
Plugin 'vim-scripts/applescript.vim'

"...All your other bundles...
if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif
" }}}

" func DoPrettyXML {{{
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
" }}}

" func ListToggle {{{
function! ListToggle()
    if &list
        set nolist
    else
        set list
    endif
endfunction
" }}}

" func NumberToggle {{{
function! NumberToggle()
    if &number
        set nonu
	GitGutterDisable
    else
        set nu
	GitGutterEnable
    endif
endfunction
" }}}

" func LineWrapToggle {{{
function! PasteToggle()
    if &wrap
        set nowrap
    else
        set wrap
    endif
endfunction
" }}}

" func PasteToggle {{{
function! PasteToggle()
    if &paste
        set nopaste
    else
        set paste
    endif
endfunction
" }}}

" Powerline Airline {{{
"set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
let g:Powerline_symbols = 'fancy'
let g:airline_theme='badwolf'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" }}}

" settings misc {{{
filetype plugin indent on			" required!
set background=dark				" Change colors to more usable on black background
set t_Co=256					" Enable 256-color mode
colorscheme twilight256				" Solarized colorscheme
syntax enable					" enable syntax highliting
hi CursorLine cterm=NONE ctermbg=233	" highlight cursorline with
hi LineNr ctermfg=16 cterm=bold ctermbg=240
set cursorline					" display line with cursor
set enc=utf-8					" Set encoding to UTF-8. Needed by powerline/airline
set termencoding=utf-8				" Set encoding to UTF-8. Needed by powerline/airline
set novisualbell				" Disable window blinking
set ruler					" Shows ruler in the bottom (not needed if 'vim-powerline is on'
set number					" Display line numbers on the left
set numberwidth=5 				" Fix width for 5 digits number
set laststatus=2				" To see powerline/airline everytime (not only in split windows).
set scrolloff=20				" Preserve 20 visible lines up/down when moving vertical
set showmatch					" Show matching bracets whern text indicator is over them
set sidescrolloff=20				" Preserve at least 10 columns on both sides of cursor?
set undolevels=200				" Number of possible undo actions
set wildignore=*.o,*.obj,*.exe,*.pyc,*.jpg,*.gif,*.png
set wildmenu					" Set command completion
set wildmode=list:longest
set autowrite					" automatically save before :next and similar commands
"set clipboard=unnamed				" s
let mapleader=","				" mapleader
set lazyredraw					" redraw only when we need to. This should lead to faster macros
set whichwrap+=<,>,[,]				" don't stop at the EOL when using arrow keys to move, preserved stop using 'h' and 'l'
set modeline        				" Last lines in document sets vim mode
set modelines=3     				" Number lines checked for modelines
" }}}

" Searching {{{
set ignorecase smartcase	" Case insensitive search, but if used uppercase use case sensitive
set hlsearch			" Highlight every presence of search prhrase
set incsearch			" Highlight search phrase on the fly

nnoremap <leader><space> :nohlsearch<CR>	" turn off search highlight
" }}}

" TABS & IDNENTS
"""""""""""""""""""
set noexpandtab			" Don't expand TABs into SPACEs
set matchtime=5			" 


" leader shortcuts {{{
map <leader>tc :tabnew! %<cr>
map <leader>tn :tabnext
map <leader>tp :tabprev
map <leader>te :tabedit
map <leader>tq :tabclose<cr>
map <leader>tm :tabmove
nmap <leader>p :cal PasteToggle()<cr>
nmap <leader>l :cal ListToggle()<cr>
nmap <leader>n :cal NumberToggle()<cr>
nmap <leader>w :cal LineWrapToggle()<cr>
vnoremap <leader>s :sort
" }}}

" maybe later {{{
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"  " change cursor in insertmode 
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"  " change cursor in insertmode
" }}}

" vim:foldmethod=marker:foldlevel=0
