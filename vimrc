set nocompatible			" just no

" #########################
" ##### Basic Changes #####
" #########################

filetype plugin indent off		" disable filetype-specific settings
syntax on				" enables syntax hilighting
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
set mouse=				" this is vim -
set nomousefocus			" no mouse
set shortmess=a				" abbreviate messages without losing information
set swapfile				" ensure we have a swapfile for recovery from crashes
set t_Co=256				" enable 256-color mode
set undofile				" save undo history in a file
set verbose=0				" don't spam screen with useless info
set visualbell				" silences the error bell
set wildmenu				" a neat menu for autocompletion
set writebackup				" ensures we don't lose files randomly

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
set splitbelow				" make horizontal splits spawn below
set title				" we like information
set titleold=couldn't\ restore\ title\ :(	" an actually useful titleold
set titlestring=%<%F\ %r%m		" show filename and modified in title

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

" ###########################
" ##### Editing Options #####
" ###########################

set autoindent				" auto indenting is nice
set backspace=indent,eol,start		" makes backspace work as expected
set cindent				" help us adhere to C-indenting
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

" Statusline. Format:
" <filepath><readonly?><modified?> <filetype> <last modified> ||| <fileformat> <ruler> 
set statusline=%<%F%r%m\ %y\ (%{strftime(\"%H:%M\ %m/%d/%Y\",getftime(expand(\"%:p\")))})\ 
	\%=[%{&ff}]\ %l-%c\ %P

" Set syntax for filetypes that aren't normally recognized
autocmd BufNewFile,BufRead *.md set syntax=markdown

" Remember the last location in a file
autocmd BufReadPost * exe "normal g`\""

" Highlight line number
autocmd ColorScheme * hi clear CursorLine
autocmd ColorScheme * hi CursorLineNr ctermfg=197

" #######################
" ##### Keybindings #####
" #######################

" disable standard movement in all modes
" Command
cnoremap <Up> <NOP>
cnoremap <Down> <NOP>
cnoremap <Left> <NOP>
cnoremap <Right> <NOP>
" Normal
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
noremap <Space> <NOP>
noremap <Backspace> <NOP>
noremap <CR> <NOP>
" Insert
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" enable ctrl+hjkl for movement when it is helpful
" Command
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
" Insert
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Insert Mode:
" auto-match braces
inoremap { {}<ESC>i

" Misc. Keybindings
" this is cool
inoremap jj <ESC>
" various shortcuts for commonly used commands
let mapleader = "\<Space>"
noremap <Leader>v <ESC>:mkview! .%.v<CR>
noremap <Leader>V <ESC>:so .%.v<CR>	
noremap <Leader>m <ESC>@m<CR>
noremap <Leader>h <ESC>:noh<CR>

" Hard Mode! Use if you want to become more familiar with harder vim movements
"noremap h <NOP>
"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>

" Adds this directory to the rtp and pp
let &runtimepath = &runtimepath . "," . expand('<sfile>:p:h')
let &packpath = &packpath . "," . expand('<sfile>:p:h')

" Reloads plugins now that we have this directory on the rtp
runtime! plugin/*.vim

" Modeline. See <:help modeline>
" vim:ts=8:ft=vim:norl
