" Basic changes...
set nocompatible			" no.
set encoding=utf-8			" hooray for good formatting.
set nobackup				" we already have enough vim turds.
set nobomb				" disabled because I primarily code.
set browsedir=last				" personal preference.
set buftype=					" make most buffers normally formatted
filetype plugin indent on

if exists("+autochdir")			" turns off automatic directory switching, if it is supported.
	set noautochdir				" 
endif " exists("+autochdir")

" Window Options
set ambiwidth=single				" for characters of undefined width, makes them single width.
set noautowrite				" manage your writes people!
set noautowriteall				" ^

if exists ("+breakindent")
	set breakindent				" line wrapping without indents is annoying.
endif " exists ("+breakindent")

if exists ("+breakindentopt")		" shift wrapped lines by one space. makes it a bit easier to tell
	set breakindentopt=shift:1	" 	you have wrapped text.
endif " exists ("+breakindentopt")

let &cpo = &cpo . "I"			"cpo options:
set clipboard=unnamed			" allow unnamed register to access comp clipboard.
set laststatus=2			" sets the status bar to two lines so it is always visible.
set number				" show line numbers,
set relativenumber			" relative line numbers that is. Use <:set rnu!> to disable.
set showmode				" show the current mode.
set visualbell					" silences the error bell.

" Buffer View Options
syntax on				" enables syntax hilighting.
set showmatch				" shows matching parentheses/brackets.

" Editing Options
set autoindent				" autoindent...
set backspace=indent,eol,start		" makes backspace work as expected.

" Adds this directory to the rtp.
let &runtimepath = &runtimepath . "," . expand('<sfile>:p:h')

" If this vim supports pp, add this directory there too,
" 	and reloads plugins.
if exists("+packpath")
	let &packpath = &packpath . "," . expand('<sfile>:p:h')
endif " has("packpath")

" Reloads plugins now that we have this directory on the rtp.
runtime! plugin/*.vim

" おはようございます。
" NOTES:
" cpoptions
" bkc

" Arrow Key Changes
" Command Mode:

cnoremap <Up> <NOP>
cnoremap <Down> <NOP>
cnoremap <Left> <NOP>
cnoremap <Right> <NOP>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

"Normal/Visual Modes:
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
noremap <Space> <NOP>
noremap <Backspace> <NOP>
noremap <Return> <NOP>

" Insert Mode:

inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" Keybind Changes
inoremap jj <ESC>
let mapleader = "\<Space>"

"HARDMODE
"noremap h <NOP>
"noremap j <NOP>
"noremap k <NOP>
"noremap l <NOP>

" CREDIT: Maker of the MINGW64 terminal default vim settings.

" Show EOL type and last modified timestamp, right after the filename 
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

"------------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    "Set UTF-8 as the default encoding for commit messages
    autocmd BufReadPre COMMIT_EDITMSG,git-rebase-todo setlocal fileencodings=utf-8

    
    " autocmd BufWrite *[^v] mkview! %.v
    " autocmd BufWinEnter *[^v] silent source %.v

    "Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$")
      \           && expand("%") !~ "COMMIT_EDITMSG"
      \           && expand("%") !~ "ADD_EDIT.patch"
      \           && expand("%") !~ "addp-hunk-edit.diff"
      \           && expand("%") !~ "git-rebase-todo" |
      \   exe "normal g`\"" |
      \ endif

      autocmd BufNewFile,BufRead *.patch set filetype=diff
      autocmd BufNewFile,BufRead *.diff set filetype=diff

      autocmd Syntax diff
      \ highlight WhiteSpaceEOL ctermbg=red |
      \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/

      autocmd Syntax gitcommit setlocal textwidth=74
endif " has("autocmd")

