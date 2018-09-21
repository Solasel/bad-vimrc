set nocompatible			" just no

" #########################
" ##### Basic Changes #####
" #########################

set noautochdir				" turns off automatic directory switching
set noautowrite				" manage your writes people!
set noautowriteall			" ^
set nobackup				" we already have enough vim turds
set nobomb				" disabled because I primarily code
set browsedir=buffer			" personal preference
set buftype=				" make most buffers normally formatted
set clipboard=unnamed			" allow unnamed register to access comp clipboard
set cpoptions+=IZ			" cpo options:
set encoding=utf-8			" hooray for good encoding schemes
set helplang="en"			" I speak english
set nohidden				" actually abandon things
set noinsertmode			" babies
set magic				" keep search patterns magic
set matchpairs+=<:>			" add <> for matching
set mouse=				" this is vim -
set nomousefocus			" no mouse
set shortmess=a				" abbreviate messages without losing information
set swapfile				" ensure we have a swapfile for recovery from crashes
set verbose=0				" don't spam screen with useless info
set visualbell				" silences the error bell
set wildmenu				" a neat menu for autocompletion
set writebackup				" ensures we don't lose files randomly
filetype plugin indent on		" try to recognize syntax and do related things

" ##########################
" ##### Window Options #####
" ##########################

set cursorline				" used to find the line the cursor is on
set foldcolumn=1			" having information about folds is useful!
set laststatus=2			" sets the status bar to two lines so it is always visible
set number				" show line numbers,
set norelativenumber			" and regular ones at that
set noruler				" statusline is our ruler
set scrolloff=3				" always keep 3 lines around cursor
set showmode				" show the current mode
set sidescrolloff=3			" keep three 3 columns around the cursor
set title				" we like information
set titlestring=%<%F\ %r%m		" show filename and modified in title
set splitbelow				" make horizontal splits spawn below

" ###############################
" ##### Buffer View Options #####
" ###############################

set foldlevelstart=0			" start by opening folds
set formatoptions="tcq2lj"		" add paragraph indentation fixes, stop vim newlining at textwidth,
					" 	and joining comments makes sense
set nolist				" default view of tabs and stuff
set listchars+=tab:>-,space:#,trail:#	" make <:list> look good
set shiftwidth=8			" matches tab width
set showbreak=+++\  			" add +++ to the start of wrapped lines
set showmatch				" shows matching parentheses/brackets
set tabstop=8				" my preferred tab width, feel free to change, but NO SPACES
set wrap				" wrapping > scrolling, for now at least
syntax on				" enables syntax hilighting

" ###########################
" ##### Editing Options #####
" ###########################

set autoindent				" auto indenting is nice
set backspace=indent,eol,start		" makes backspace work as expected
set noexpandtab				" let people look at code their way
set nopaste				" trust me, you don't need this
set nrformats+=alpha			" allows inc/dec of alpha characters
set selectmode=				" select mode isn't cool
set virtualedit=block			" allows selection of virtual text while in visual block
set whichwrap=				" wrapping movement is annoying and serves no purpose

" ###########################
" ##### Command Options #####
" ###########################

set noesckeys				" makes esc more responsive when in ins mode
set hlsearch				" highlight search terms
set ignorecase				" most of the time this helps. use \C to force case-matching
set incsearch				" personal preference
set nojoinspaces			" make join work as expected
set remap				" allow recursion for key mappings
set report=0				" always report number of changes
set tildeop				" tilde op is nice
set startofline				" for large movements, move the cursor to the start of line

" ##########################
" ##### Misc. Settings #####
" ##########################

" Status bar. Format:
" <filepath><readonly?><modified?> <filetype> <last modified> ||| <fileformat> <ruler> 
set statusline=%<%F%r%m\ %y\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})\ 
	\%=[%{&ff}]\ %l-%c\ %P

" I've had problems with .md files before
autocmd BufNewFile,BufRead *.md set syntax=markdown

" Jump to the previous location in the file
autocmd BufReadPost * exe "normal g`\""

" Make the line number that the cursor is on be colored red
autocmd ColorScheme * hi clear CursorLine
autocmd ColorScheme * hi CursorLineNr ctermfg=red
	

" #######################
" ##### Keybindings #####
" #######################

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
inoremap ( ()<ESC>i			" automatically close group symbols
inoremap [ []<ESC>i
inoremap { {}<ESC>i

" Misc. Keybindings
inoremap jj <ESC>
let mapleader = "\<Space>"
noremap <Leader>v :mkview! .%.v<CR>	" make a view file with your current view
noremap <Leader>V :so .%.v<CR>		" load a saved view file
noremap <Leader>w :w<CR>		" write faster
noremap <Leader>m @m<CR>		" faster macro execution
noremap <Leader>h :noh<CR>		" turn off highlighting

" Hard Mode! Use if you want to become more familiar with harder vim movements
"noremap h <NOP>
"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>

" Adds this directory to the rtp
let &runtimepath = &runtimepath . "," . expand('<sfile>:p:h')

" If this vim supports pp, add this directory there too
if exists("+packpath")
	let &packpath = &packpath . "," . expand('<sfile>:p:h')
endif " has("packpath")

" Reloads plugins now that we have this directory on the rtp
runtime! plugin/*.vim

" Modeline. See <:help modeline>
" vim:ts=8:ft=vim:norl

