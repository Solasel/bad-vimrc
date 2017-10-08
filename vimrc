" Basic changes...
set nocompatible			" no.
set encoding=utf-8
filetype plugin indent on

" Window Options
set clipboard=unnamed			" allow unnamed register to access comp clipboard.
set laststatus=2			" sets the status bar to two lines so it is always visible.
set number				" show line numbers,
set rnu					" relative line numbers that is. Use <:set rnu!> to disable.
set showmode				" show the current mode.
set vb					" silences the error bell.

" Buffer View Options
syntax on				" enables syntax hilighting.
set showmatch				" shows matching parentheses/brackets.

" Editing Options
set ai					" autoindent...
set backspace=indent,eol,start		" makes backspace work as expected.

" Adds this directory to the rtp and pp.
let &runtimepath = &runtimepath . "," . expand('<sfile>:p:h')
let &packpath = &packpath . "," . expand('<sfile>:p:h')

" Reloads plugins now that we're added to pp.
runtime! plugin/*.vim

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
noremap <Space> <NOP>
noremap <Backspace> <NOP>
noremap <Return> <NOP>

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
