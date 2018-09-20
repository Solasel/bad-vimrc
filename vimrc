" Basic Changes

set nocompatible			" just no
set nopaste				" enable this if you need to. you don't
set remap				" allow recursion for key mappings
set encoding=utf-8			" hooray for good encoding schemes
set nobackup				" we already have enough vim turds
set nobomb				" disabled because I primarily code
set browsedir=buffer			" personal preference
set buftype=				" make most buffers normally formatted
set noesckeys				" makes esc more responsive when in ins mode 
set nohidden				" actually abandon things
set hlsearch				" highlight search terms
set ignorecase				" most of the time this helps. use \C to force case-matching
set mouse=				" this is vim -
set nomousefocus			" no mouse
set nrformats+=alpha			" allows inc/dec of alpha characters
set report=0				" always report number of changes
set noruler				" statusline is our ruler
set selectmode=				" select mode isn't cool
set shortmess=a				" abbreviate messages without losing information
set startofline				" for large movements, move the cursor to the start of line
set swapfile				" ensure we have a swapfile for recovery from crashes

" Status bar. Format:
" <filepath><readonly?><modified?> <filetype> <last modified> ||| <fileformat> <ruler> 
set statusline=%<%F%r%m\ %y\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})\ 
	\%=[%{&ff}]\ %l-%c\ %P

filetype plugin indent on		" help us make files look pretty

set noautochdir				" turns off automatic directory switching

" Window Options

set ambiwidth=single			" for characters of undefined width, makes them single width
set noautowrite				" manage your writes people!
set noautowriteall			" ^
set splitbelow				" make horizontal splits spawn below
set splitright				" make vertical splits spawn to the right
set cpoptions+=IZ			" cpo options:
set laststatus=2			" sets the status bar to two lines so it is always visible
set number				" show line numbers,
set relativenumber			" relative line numbers that is. Use <:set rnu!> to disable
set showmode				" show the current mode
set visualbell				" silences the error bell
set helplang="en"			" I speak english
set scrolloff=3				" always keep 3 lines around cursor
set sidescrolloff=3			" ^

" Buffer View Options

syntax on				" enables syntax hilighting
set showmatch				" shows matching parentheses/brackets

" Editing Options
set autoindent				" auto indenting is nice
set backspace=indent,eol,start		" makes backspace work as expected
set clipboard=unnamed			" allow unnamed register to access comp clipboard
set nodigraph
set noexpandtab				" let people look at code their way
set foldcolumn=1			" having information about folds is useful!
set foldlevelstart=0			" start by opening folds
set formatoptions="tcq2lj"		" add paragraph indentation fixes, stop vim newlining at textwidth,
					" 	and joining comments makes sense
set incsearch				" personal preference
set noinsertmode			" babies
set nojoinspaces			" make join work as expected
set nolist				" default view of tabs and stuff
set listchars+=tab:>-,space:#,trail:#	" make <:list> look good
set magic				" keep search patterns magic
set matchpairs+=<:>			" add <> for matching
set shiftwidth=8			" matches tab width
set tabstop=8				" my preferred tab width
set showbreak=+++\  			" add +++ to the start of wrapped lines

noh					" remove highlighting, mostly for hlsearch

" Adds this directory to the rtp
let &runtimepath = &runtimepath . "," . expand('<sfile>:p:h')

" If this vim supports pp, add this directory there too
if exists("+packpath")
	let &packpath = &packpath . "," . expand('<sfile>:p:h')
endif " has("packpath")

" Reloads plugins now that we have this directory on the rtp
runtime! plugin/*.vim

" I've had problems with .md files before
autocmd BufNewFile,BufRead *.md set syntax=markdown

" Jump to the previous location in the file
autocmd BufReadPost * exe "normal g`\""

" Keybindings

" Command Mode:

cnoremap <Up> <NOP>			" disable arrow keys because elitism
cnoremap <Down> <NOP>
cnoremap <Left> <NOP>
cnoremap <Right> <NOP>
cnoremap <C-h> <Left>			" add ctrl movement so we can move around
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

"Normal/Visual Modes:
noremap <Up> <NOP>			" again, elitism
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
noremap <Space> <NOP>
noremap <Backspace> <NOP>

" Insert Mode:

inoremap <Up> <NOP>			" learn to use hjkl guys
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
inoremap <C-h> <Left>			" this sometimes helps
inoremap <C-l> <Right>

" Keybind Changes
inoremap jj <ESC>
let mapleader = "\<Space>"
noremap <Leader>v :mkview! .%.v<CR>	" make a view file with your current view
noremap <Leader>V :so .%.v<CR>		" load a saved view file
noremap <Leader>w :w<CR>		" write faster
noremap <Leader>m @m<CR>		" faster macro execution
noremap <Leader>h :noh<CR>		" turn off highlighting

"HARDMODE
"noremap h <NOP>
"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>

" NOTES:
" cpoptions
" formatprg

