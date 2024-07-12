" settings basic {{{
set nocompatible		" be iMproved, needed by a lot of plugins
set shortmess=I			" Hide splash screen
filetype off			" required!
" }}}

let g:ale_lint_on_text_changed = 'always'
let g:ale_puppet_languageserver_executable = '~/.config/nvim/plugged/puppet-editor-services/puppet-languageserver'

let g:editorconfig = v:false
" Plug configuration {{{
let plug_installed=expand('~/.vim/autoload/plug.vim')
if !filereadable(plug_installed)
	echo "Installing plug.."
	echo ""
	silent !curl -NsfLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
call plug#begin()
  Plug 'muhmud/qsh', { 'dir': '~/.qsh/editors/vim' }
  Plug 'lingua-pupuli/puppet-editor-services'
  Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
  Plug 'airblade/vim-gitgutter'
  Plug 'luochen1990/rainbow'
  Plug 'neomutt/neomutt.vim'
  Plug 'adborden/vim-notmuch-address'
  Plug 'vim-scripts/AnsiEsc.vim'
  Plug 'rodjek/vim-puppet'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdtree'
  "Plug 'editorconfig/editorconfig-vim'
  Plug 'tpope/vim-fugitive'
  Plug 'rkitover/vimpager'
  Plug 'hashivim/vim-terraform'
  Plug 'hashicorp/terraform-ls'
  Plug 'juliosueiras/vim-terraform-completion'
  Plug 'vim-syntastic/syntastic'
  Plug 'morhetz/gruvbox'
  Plug 'speshak/vim-cfn'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-scripts/applescript.vim'
  Plug 'vim-scripts/gitvimdiff'
  Plug 'vim-scripts/haproxy'
  Plug 'vim-scripts/ldap_schema.vim'
  Plug 'vim-scripts/ldif.vim'
  Plug 'mechatroner/rainbow_csv'
  Plug 'w0rp/ale'
  Plug 'wincent/command-t'
call plug#end()
" }}}

" qsh
vnoremap <silent> <F5> :call QshExecuteSelection()<CR>

" {{{ functions
" func DoPrettyXML {{{
function! DoPrettyXML()
	let l:origft = &ft " save the filetype so we can restore it later
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
	set list!
endfunction
" }}}

" func NumberToggle {{{
function! NumberToggle()
	set nonu!
	set nornu!
	if &number
		GitGutterDisable
	else
		GitGutterEnable
	endif
endfunction
" }}}

" func LineWrapToggle {{{
function! LineWrapToggle()
	set wrap!
endfunction
" }}}

" func PasteToggle {{{
function! PasteToggle()
	set paste!
endfunction
" }}}

" func CopyToSystemClipboardToggle {{{
function! CopyToSystemClipboardToggle()
	if &clipboard == 'unnamed'
		set clipboard=
		echo "System clipboard unset"
	else
		set clipboard=unnamed
		echo "System clipboard set"
	endif
endfunction
" }}}

" func MouseToggle {{{
function! MouseToggle()
	if &mouse == 'a'
		set mouse=
	else
		set mouse=a
	endif
endfunction
" }}}
" }}}
"

let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0

" {{{ naseptavani
let g:deoplete#enable_at_startup = 1
" let g:deoplete#omni_patterns = {}
" call deoplete#custom#option('omni_patterns', {
" \ 'complete_method': 'omnifunc',
" \ 'terraform': '[^ *\t"{=$]\w*',
" \})
call deoplete#custom#option('sources', {
\ '_': ['ale'],
\})
call deoplete#initialize()
set completeopt=menu,menuone,preview,noselect,noinsert

	
let g:notmuch_address_tag = 'sent'

" syntastic 
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"
"set completeopt-=preview
"
"" (Optional)Hide Info(Preview) window after completions
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"
"" (Optional) Enable terraform plan to be include in filter
"let g:syntastic_terraform_tffilter_plan = 1
"
"" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
"let g:terraform_completion_keys = 1
"
"" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
"let g:terraform_registry_module_completion = 0
" }}}


if exists('+termguicolors')
  set termguicolors
endif
let g:airline = {}
let g:airline.colorscheme = 'gruvbox'
colorscheme gruvbox
" Powerline Airline {{{
let g:Powerline_symbols = 'fancy'
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" }}}

" settings misc {{{
filetype plugin indent on			" required!
"set background=dark				" i have dark background
"colorscheme neodark				" set color scheme
" let g:neodark#terminal_transparent = 1 " default: 0
" let g:neodark#solid_vertsplit = 1
" let g:neodark#background = '#000000'
syntax enable					" enable syntax highliting
hi CursorLine cterm=NONE ctermbg=233		" highlight cursorline with
hi LineNr ctermfg=16 cterm=bold ctermbg=240
set cursorline					" display line with cursor
set enc=utf-8					" Set encoding to UTF-8. Needed by powerline/airline
set termencoding=utf-8				" Set encoding to UTF-8. Needed by powerline/airline
set novisualbell				" Disable window blinking
set title					" show filename in terminal title
set ruler					" Shows ruler in the bottom (not needed if 'vim-powerline is on'
set number					" Display line numbers on the left
set rnu						" relative numbers
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
set whichwrap+=<,>,[,]				" don't stop at the EOL when using arrow keys, preserved stop using 'h' and 'l'
set modeline        				" Last lines in document sets vim mode
set modelines=3     				" Number lines checked for modelines
" }}}

" Searching {{{
set ignorecase smartcase	" Case insensitive search, but if used uppercase use case sensitive
set hlsearch			" Highlight every presence of search prhrase
set incsearch			" Highlight search phrase on the fly

nnoremap <leader><space> :nohlsearch<CR>	" turn off search highlight
" }}}

set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set ttyfast

" TABS & IDNENTS
"""""""""""""""""""
set noexpandtab			" Don't expand TABs into SPACEs
set matchtime=5			" blink matching paren for 500ms

" leader shortcuts {{{
map <leader>t :CommandT					" commandt
map <leader>n :next					" next window
map <leader>p :prev					" prev window
map <leader>tc :tabnew! %<cr>				" new tab
map <leader>tn :tabnext					" next tab
map <leader>tp :tabprev					" prev tab
map <leader>te :tabedit					" open tab and edit file
map <leader>tq :tabclose<cr>				" close tab
map <leader>tm :tabmove					" move tab
nmap <leader>c :cal CopyToSystemClipboardToggle()<cr>	" toggle system clipboard
nmap <leader>p :cal PasteToggle()<cr>			" toggle paste
nmap <leader>l :cal ListToggle()<cr>			" toggle list
nmap <leader>n :cal NumberToggle()<cr>			" toggle number
nmap <leader>w :cal LineWrapToggle()<cr>		" toggle line
nmap <leader>m :cal MouseToggle()<cr>			" toggle mouse
noremap <leader>W :w !sudo tee % > /dev/null<CR>	" save file as root
vnoremap <leader>s :sort
" }}}

vmap gs y'>p:'[,']-1s/$/+/\|'[,']+1j!<CR>'[0"wy$:.s§.*§\=w§<CR>'[yyP:.s/./=/g<CR>_j

"{{{ vimpager only settings and overwrites
if exists('g:vimpager.enabled')
  let vimpager_passthrough=1
  "let g:less = { 'enabled': 1 } " less compatibility mode
  let g:vimpager.ansiesc = 1
  autocmd BufRead * AnsiEsc
  set nornu
  set nu
endif
"}}}

set t_BE= 

let g:CommandTPreferredImplementation='lua'
let g:rainbow_active = 0 "0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf={
	\ 'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\ 'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\ 'operators': '_,_',
	\ 'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\ 'separately': {
	\   '*': {},
	\ }
\}

" vim:foldmethod=marker:foldlevel=0
