""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TABs/indentation options
set expandtab       " expand tabs to spaces
set tabstop=4       " number of spaces tab is counted for
set softtabstop=0   " cause <BS> key to delete correct number of spaces
set shiftwidth=4    " number of spaces to use for autoindent

" line marking options
set number          " show line numbers
set relativenumber  " show line numbers relative to cursor position
set cursorline      " mark current line
"
set colorcolumn=91  " position of vertical line
set nowrap          " never wrap lines

" highliting options
set showmatch       " show matching brackets

" indentation options
set cindent         " turn on C style indentation
set listchars+=space:·,trail:·,tab:»·,eol:¶

" searching in files
set hlsearch        " highlight search results
set noic            " be case sensitive

set mouse=a
filetype plugin on

" spell checker
" set spell           " uses english language by default
" set spelllang=en,de " change default language of spell checker

" fold method
"set foldmethod=syntax

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                               plugin management
"
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"
call plug#begin('~/.vim/plugged')

" general
Plug 'tpope/vim-sensible'               " a universal set of defaults

call plug#end()
