function! s:is_installed(...)
    for bin in a:000
        if !executable(bin)
            if !exists("l:missing")
                let l:missing = [ bin ]
            else
                call add(l:missing, bin)
            endif
        endif
    endfor

    if exists("l:missing")
        echoerr 'Following utilities are required but not found in $PATH: ' . string(l:missing)
        return 0
    else
        return 1
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             plugin management
"
let vimplug_path=expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vimplug_path)
    if !s:is_installed('cmake', 'curl', 'git', 'g++', 'pip3', 'python', 'python3')
        echoerr "Continuing without any customizations..."
        finish
    else
        echo "\nInstalling Vim-Plug...\n"
        exec "!curl -fLo " . vimplug_path . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        exec "!python -m pip install setuptools"
        exec "!pip3 install --upgrade --user pynvim"
        autocmd VimEnter * PlugInstall --sync
    endif
endif
call plug#begin(expand('~/.config/nvim/plugged'))

" general
Plug 'tpope/vim-sensible'               " a universal set of defaults

" look & feel
Plug 'itchyny/lightline.vim'            " configurable status line
Plug 'mhinz/vim-startify'               " nice welcome screen
" themes
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'danilo-augusto/vim-afterglow'
Plug 'jacoborus/tender.vim'
Plug 'jnurmine/Zenburn'
Plug 'joshdick/onedark.vim'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'KeitaNakamura/neodark.vim'
Plug 'morhetz/gruvbox'
Plug 'sjl/badwolf'
Plug 'sonph/onehalf', { 'rtp': 'vim/' }
Plug 'tomasiser/vim-code-dark'
Plug 'flrnprz/plastic.vim'
Plug 'romainl/Apprentice'

" git
Plug 'tpope/vim-fugitive'               " best git wrapper of all time

" tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" command line fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" convert vim into an awesome IDE
Plug 'ntpeters/vim-better-whitespace'   " colorize trailing white spaces
Plug 'sheerun/vim-polyglot'             " syntax highlighting for many languages
Plug 'shime/vim-livedown'
Plug 'SirVer/ultisnips'                 " snippets management
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --clang-completer' }
Plug 'Yggdroot/indentLine'              " show indentation levels
Plug 'rhysd/vim-clang-format'

call plug#end()


" Remap leader key
let mapleader = "\<Space>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            plugin customization
"
" Needs vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
    set termguicolors
endif
"
let g:onedark_termcolors = 256
colorscheme onedark
"
let s:plugins_customization_script=expand('~/.config/nvim/plugins-customized.vim')
if filereadable(s:plugins_customization_script)
    execute "source " . s:plugins_customization_script
else
    echoerr 'Plugin customization script' . s:plugins_customization_script . ' not readable!'
endif
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 shortcuts
"
" Fast split/window navigation with <Ctrl-hjkl>
nnoremap <C-h> <C-w><C-h>
inoremap <C-h> <C-o><C-w><C-h>
nnoremap <C-j> <C-w><C-j>
inoremap <C-j> <C-o><C-w><C-j>
nnoremap <C-k> <C-w><C-k>
inoremap <C-k> <C-o><C-w><C-k>
nnoremap <C-l> <C-w><C-l>
inoremap <C-l> <C-o><C-w><C-l>

" create new split/tab window
nnoremap <leader>bh :new<CR>
nnoremap <leader>bv :vnew<CR>

" working with tabs
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tm :tabmove
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>l  :tabnext<CR>
nnoremap <leader>h  :tabprevious<CR>

" scroll one page up/down
nnoremap <leader>n <PageDown>
nnoremap <leader>p <PageUp>
" scroll one half page up/down
nnoremap <leader>k <C-u>
nnoremap <leader>j <C-d>

" exit a session
nnoremap <leader>q :qa<CR>
nnoremap <leader>w :conf wqa<CR>
"
" toggle whitespaces
nnoremap <leader>7 :set list!<CR>
" stop highlighting
nnoremap <leader><CR> :nohlsearch<CR>

" switch CWD to the directory of the open buffer
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" TABs/indentation options
set expandtab               " expand tabs to spaces
set tabstop=4               " number of spaces tab is counted for
set softtabstop=0           " cause <BS> key to delete correct number of spaces
set shiftwidth=4            " number of spaces to use for auto indent
filetype plugin indent on   " indentation based on file type
set listchars+=space:·,trail:·,tab:»·,eol:¶

" highlighting options
set number                  " show line numbers
set relativenumber          " show line numbers relative to cursor position
set cursorline              " mark current line
set showmatch               " show matching brackets
set colorcolumn=91          " position of vertical line

" splitting
set splitbelow              " put new split windows to the bottom of the current
set splitright              " put new vsplit windows to the right of the current

" searching in files
set hlsearch                " highlight search results
set ignorecase              " case insensitive search
set smartcase               " case sensitive only if search contains uppercase letter

" line wrapping options
set nowrap                  " never wrap lines

" scrolling
set scrolloff=1             " minimum number of lines to show above and below the cursor

" general
set mouse=a                 " use mouse
set showcmd                 " show incomplete commands in the bottom right corner

" spell checker
set spell                   " uses English language by default
set spelllang=en_us         " change default language of spell checker

" save undo history
if has("persistent_undo")
    set undofile
    set undodir=~/.config/nvim/undodir
endif

" fold method
"set foldmethod=syntax

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

packloadall             " load all plugins
silent! helptags ALL    " load help files for all plugins

