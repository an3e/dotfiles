function! s:is_installed(...)
    let l:rv=1
    for bin in a:000
        if !executable(bin)
            echohl WarningMsg | echo "[ " . bin . " ] is required but not found in \$PATH" | echohl None
            let l:rv=0
        endif
    endfor
    return l:rv
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             plugin management
"
let vimplug_path=expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vimplug_path)
    if !s:is_installed('cmake', 'curl', 'git', 'g++', 'pip3', 'python', 'python3')
        execute "q!"
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
Plug 'nanotech/jellybeans.vim'
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
" plugin 'lightline'
let g:lightline = {
            \ 'colorscheme': 'onedark',
            \ 'active': {
            \ 'left': [ [ 'mode', 'paste' ],
            \           [ 'gitbranch', 'readonly', 'filename', 'modified' ],
            \           [ 'gutentags' ] ],
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head',
            \   'gutentags': 'gutentags#statusline'
            \ },
            \ }
" plugin 'vim-startify'
let g:startify_session_autoload = 1     " load sessions automatically
let g:startify_session_persistence = 1  " save sessions on exit
"
" plugin 'vim-cpp-enhanced-highlight'(part of 'vim-polyglot')
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1 " not sure if it has some effect
let g:cpp_class_decl_highlight = 1
"
" plugin 'indentLine'
let g:indentLine_char = '┊'
let g:indentLine_conceallevel = 1
"
" plugin 'vim-gutentags'
let g:gutentags_cache_dir = '~/.cache/gutentags'
let g:gutentags_project_root = ['.git/']        " '/' to make sure sub modules are ignored
let g:gutentags_add_default_project_roots = 0   " do not add any default project roots
let g:gutentags_exclude_filetypes = ['log']
" make sure gutentags correctly updates it's status in lightline
augroup GutentagsLightlineRefresher
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
augroup END
"
" plugin 'vim-better-whitespaces'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
"
"plugin UltiSnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<c-i>"
let g:UltiSnipsJumpBackwardTrigger="<c-o>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories=['UltiSnips']
"
" plugin 'YouCompleteMe'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_error_symbol = '✘'
let g:ycm_warning_symbol = '⚠'
"
" plugin 'fzf'
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }
"
" plugin 'vim-clang-format'
let g:clang_format#command="/usr/bin/clang-format-7"
let g:clang_format#code_style="llvm"
let g:clang_format#style_options = {
\ "AccessModifierOffset": -4,
\ "AlignAfterOpenBracket": "DontAlign",
\ "AllowAllParametersOfDeclarationOnNextLine": "true",
\ "AllowShortBlocksOnASingleLine": "false",
\ "AllowShortCaseLabelsOnASingleLine": "false",
\ "AllowShortFunctionsOnASingleLine": "Empty",
\ "AlwaysBreakTemplateDeclarations": "true",
\ "BinPackArguments": "false",
\ "BinPackParameters": "false",
\ "BraceWrapping": {
\    "AfterClass": "true",
\    "AfterControlStatement": "true",
\    "AfterEnum": "true",
\    "AfterFunction": "true",
\    "AfterNamespace": "false",
\    "AfterObjCDeclaration": "true",
\    "AfterStruct": "true",
\    "AfterUnion": "true",
\    "BeforeCatch": "true",
\    "BeforeElse": "true",
\    "IndentBraces": "false" },
\ "BreakBeforeBraces": "Custom",
\ "BreakConstructorInitializers": "BeforeComma",
\ "ColumnLimit": 0,
\ "Cpp11BracedListStyle": "true",
\ "IncludeBlocks": "Preserve",
\ "IndentWidth": 4,
\ "IndentCaseLabels": "true",
\ "IndentWrappedFunctionNames": "false",
\ "MaxEmptyLinesToKeep": 1,
\ "NamespaceIndentation": "None",
\ "PointerAlignment": "Left",
\ "SortIncludes": "false",
\ "SpaceBeforeParens": "Never",
\ "SpacesInAngles": "false",
\ "SpacesInContainerLiterals": "false",
\ "SpacesInParentheses": "false",
\ "SpacesInSquareBrackets": "false",
\ "SortUsingDeclarations": "false",
\ "Standard": "Cpp11",
\ "TabWidth": 4,
\ "UseTab": "Never"}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           control key shortcuts
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            leader key shortcuts
" Remap leader key
let mapleader = "\<Space>"
"
" plugin vim-clang-format
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
"
" plugin 'fzf'
function! FzfSearchFileNames()
    let $FZF_DEFAULT_COMMAND = 'ag --depth -1 --hidden --ignore .git -l -g ""'
    let $FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'
                \ --bind ctrl-f:page-down,ctrl-b:page-up"
    let $BAT_THEME="zenburn"
    :Files
endfunction
"
function! FzfSearchFileContent()
    let $FZF_DEFAULT_OPTS=''
    :Ag
endfunction
"
function! FzfSearchKeyMappings()
    let $FZF_DEFAULT_OPTS=''
    :Maps
endfunction
"
nnoremap <leader>fa :call FzfSearchFileContent()<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Colors<CR>
nnoremap <leader>ff :call FzfSearchFileNames()<CR>
nnoremap <leader>fg :Commits<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>fm :call FzfSearchKeyMappings()<CR>
nnoremap <leader>fs :Snippets<CR>
nnoremap <leader>ft :Tags<CR>
" use preview when FzFiles runs in fullscreen
command! -nargs=? -bang -complete=dir FzfFiles
            \ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:65%') : {}, <bang>0)
command FzfChanges call s:fzf_changes()
nnoremap <leader>fv :FzfFiles!<CR>
nnoremap <leader>fy :Filetypes<CR>
nnoremap <leader>fw :Windows<CR>
"
" plugin vim-fugitive
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gcommit -s -v<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gl :Gpull<CR>
nnoremap <leader>gp :Gpush --force-with-lease<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gw :Gwrite<CR>

" create new split/tab window
nnoremap <leader>nh :new<CR>
nnoremap <leader>nv :vnew<CR>
nnoremap <leader>nt :tabnew<CR>

" working with tabs
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>tm :tabmove
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>l  :tabnext<CR>
nnoremap <leader>h  :tabprevious<CR>

" scrolling in buffers
nnoremap <leader>j <PageDown>
nnoremap <leader>k <PageUp>

" exit a session
nnoremap <leader>q :qa<CR>
nnoremap <leader>w :conf wqa<CR>
"
" plugin YouCompleteMe
nnoremap <leader>yd :YcmCompleter GetDoc<CR>
nnoremap <leader>yp :YcmCompleter GetParent<CR>
nnoremap <leader>yc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>yf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yh :YcmCompleter GoToHeader<CR>

" open/close tag preview window (:ptag <name_under_cursor>)
nnoremap <leader>2 <C-w>}
nnoremap <leader>" <C-w>z
" jump/return to/from tag under cursor
nnoremap <leader>3 <C-]>
nnoremap <leader>§ <C-t>
" open file under cursor / go to symbol declaration/definition.
nnoremap <leader>4 :leftabove vertical YcmCompleter GoTo<CR>
" refresh compilation diagnostics
nnoremap <leader>5 :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>6 :YcmCompleter GetType<CR>
" toggle whitespaces
nnoremap <leader>7 :set list!<CR>
" toggle the tagbar (needs https://github.com/majutsushi/tagbar)
nnoremap <leader>8 :TagbarToggle<CR>
" accept fixit proposals from YouCompleteMe
nnoremap <leader>9 :YcmCompleter FixIt<CR>

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
set scrolloff=2             " minimum number of lines to show above and below the cursor

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

