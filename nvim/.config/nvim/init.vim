" init: remap leader key {{{
let mapleader = "\<Space>"
" }}}

" user defined functions {{{
func! s:is_installed(...)
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
endfunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

func! s:visual_selection(direction, extra_filter) range
let l:saved_reg = @"
	execute "normal! vgvy"

	let l:pattern = escape(@", "\\/.*'$^~[]")
	let l:pattern = substitute(l:pattern, "\n$", "", "")

	if a:direction == 'gv'
		call CmdLine("Ack '" . l:pattern . "' " )
	elseif a:direction == 'replace'
		call CmdLine("%s" . '/'. l:pattern . '/')
	endif

	let @/ = l:pattern
	let @" = l:saved_reg
endfunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

func! s:strip_trailing_whitespaces()
	let l:blacklist = ['markdown']
	if index(l:blacklist, &ft) < 0
		%s/\s\+$//e
	endif
endfunc

" }}}

" automatically install vim-plug {{{
let s:vimplug_path=expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(s:vimplug_path)
	if !s:is_installed('cmake', 'ctags', 'curl', 'git', 'g++', 'pip3', 'python', 'python3')
		echoerr "Continuing without any customizations..."
		finish
	else
		echo "\nInstalling Vim-Plug...\n"
		exec "!curl -fLo " . s:vimplug_path . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
		exec "!python -m pip install setuptools"
		exec "!pip3 install --upgrade --user pynvim"
		autocmd VimEnter * PlugInstall --sync
	endif
endif
" }}}
call plug#begin(expand('~/.config/nvim/plugged')) " start of plugin installation {{{
" }}}
" universal set of defaults from vim-sensible {{{
Plug 'tpope/vim-sensible'
" }}}
" look & feel {{{
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
let s:color_scheme = 'onedark'

Plug 'itchyny/lightline.vim'	" configurable status line
let g:lightline = {
			\ 'colorscheme': s:color_scheme,
			\ 'active': {
			\ 'left': [ [ 'mode', 'paste' ],
			\			[ 'gitbranch', 'readonly', 'filename', 'modified' ],
			\			[ 'gutentags' ] ],
			\ },
			\ 'component_function': {
			\	'gitbranch': 'fugitive#head',
			\	'gutentags': 'gutentags#statusline'
			\ },
			\ }

Plug 'mhinz/vim-startify'				" nice welcome screen
let g:startify_session_autoload = 1		" load sessions automatically
let g:startify_session_persistence = 1	" save sessions on exit
let g:startify_bookmarks = [ {'v': '~/.config/nvim/init.vim'}, {'z': '~/.zshrc'} ]

"}}}
" git {{{
Plug 'tpope/vim-fugitive'	" best git wrapper of all time :)
" shortcuts
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gcommit -s -v<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gl :Gpull<CR>
nnoremap <leader>gp :Gpush --force-with-lease<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gw :Gwrite<CR>
" configuration
autocmd Filetype gitcommit setlocal spell textwidth=72
" }}}
" tags {{{
Plug 'ludovicchabant/vim-gutentags'
	let g:gutentags_add_default_project_roots = 0	" do not add any default project roots
	let g:gutentags_cache_dir = '~/.cache/gutentags'
	let g:gutentags_exclude_filetypes = ['log']
	let g:gutentags_project_root = ['.git/']		" '/' to ignore submodules
	let g:gutentags_resolve_symlinks = 1
	if exists("g:lightline")
		" make sure gutentags correctly updates it's status in lightline
		augroup GutentagsLightlineRefresher
			autocmd!
			autocmd User GutentagsUpdating call lightline#update()
			autocmd User GutentagsUpdated call lightline#update()
		augroup END
	endif
	" open/close tag preview window (:ptag <name_under_cursor>)
	nnoremap <leader>2 <C-w>}
	nnoremap <leader>" <C-w>z
	" jump/return to/from tag under cursor
	nnoremap <leader>3 <C-]>
	nnoremap <leader>§ <C-t>

Plug 'majutsushi/tagbar'
nnoremap <leader>8 :TagbarToggle<CR>
" }}}
" command line fuzzy finder (fzf) {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_nvim_statusline = 0 " disable statusline overwriting
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_colors = {
			\ 'fg':		['fg', 'Normal'],
			\ 'bg':		['bg', 'Normal'],
			\ 'hl':		['fg', 'Comment'],
			\ 'fg+':	['fg', 'CursorLine', 'CursorColumn', 'Normal'],
			\ 'bg+':	['bg', 'CursorLine', 'CursorColumn'],
			\ 'hl+':	['fg', 'Statement'],
			\ 'info':	['fg', 'PreProc'],
			\ 'border':	['fg', 'Ignore'],
			\ 'pointer':['fg', 'Exception'],
			\ 'marker':	['fg', 'Keyword'],
			\ 'spinner':['fg', 'Label'],
			\ 'header':	['fg', 'Comment'] }

function! FzfSearchFileNames()
	if executable('ag')
		let $FZF_DEFAULT_COMMAND = 'ag --depth -1 --hidden --ignore .git -l -g ""'
		if !executable('bat')
			let $FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'
						\ --bind ctrl-f:page-down,ctrl-b:page-up"
		else
			let $FZF_DEFAULT_OPTS="--preview 'cat {}'"
		endif
		let $BAT_THEME="zenburn"
		:Files
	else
		echoerr 'Utility [ag] is not available. Please set it up!'
	endif
endfunction

function! FzfSearchFileContent()
	if executable('ag')
		let $FZF_DEFAULT_OPTS=''
		:Ag
	else
		echoerr 'Utility [ag] is not available. Please set it up!'
	endif
endfunction

function! FzfSearchKeyMappings()
	let $FZF_DEFAULT_OPTS=''
	:Maps
endfunction

nnoremap <leader>fa :call FzfSearchFileContent()<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Colors<CR>
nnoremap <leader>ff :call FzfSearchFileNames()<CR>
nnoremap <leader>fg :Commits<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fl :BLines<CR>
nnoremap <leader>fm :call FzfSearchKeyMappings()<CR>
nnoremap <leader>fs :Snippets<CR>
nnoremap <leader>ft :call fzf#vim#tags(expand('<cword>'))<CR>
" use preview when FzFiles runs in fullscreen
command! -nargs=? -bang -complete=dir FzfFiles
			\ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:65%') : {}, <bang>0)
nnoremap <leader>fv :FzfFiles!<CR>
nnoremap <leader>fy :Filetypes<CR>
nnoremap <leader>fw :Windows<CR>
" }}}
" convert vim into an awesome IDE {{{
Plug 'sheerun/vim-polyglot'	" syntax highlighting for many languages
let g:cpp_class_decl_highlight = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1 " not sure if it has some effect

Plug 'shime/vim-livedown'
Plug 'SirVer/ultisnips'	" snippets management
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<c-i>"
let g:UltiSnipsJumpBackwardTrigger="<c-o>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories=['UltiSnips']

Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 ./install.py --clang-completer' }
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_error_symbol = '✘'
let g:ycm_warning_symbol = '⚠'
nnoremap <leader>yd :YcmCompleter GetDoc<CR>
nnoremap <leader>yp :YcmCompleter GetParent<CR>
nnoremap <leader>yc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>yf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yh :YcmCompleter GoToHeader<CR>
" open file under cursor / go to symbol declaration/definition.
nnoremap <leader>4 :rightbelow vertical YcmCompleter GoTo<CR>
nnoremap <leader>5 :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>6 :YcmCompleter GetType<CR>
nnoremap <leader>9 :YcmCompleter FixIt<CR>

Plug 'Yggdroot/indentLine'
let g:indentLine_char = '┊'
let g:indentLine_conceallevel = 1

Plug 'rhysd/vim-clang-format'
let g:clang_format#command="/usr/bin/clang-format-7"
let g:clang_format#code_style="llvm"
let g:clang_format#style_options = {
	\	"AccessModifierOffset": -4,
	\	"AlignAfterOpenBracket": "DontAlign",
	\	"AllowAllParametersOfDeclarationOnNextLine": "true",
	\	"AllowShortBlocksOnASingleLine": "false",
	\	"AllowShortCaseLabelsOnASingleLine": "false",
	\	"AllowShortFunctionsOnASingleLine": "Empty",
	\	"AlwaysBreakTemplateDeclarations": "true",
	\	"BinPackArguments": "false",
	\	"BinPackParameters": "false",
	\	"BraceWrapping": {
	\		"AfterClass": "true",
	\		"AfterControlStatement": "true",
	\		"AfterEnum": "true",
	\		"AfterFunction": "true",
	\		"AfterNamespace": "false",
	\		"AfterObjCDeclaration": "true",
	\		"AfterStruct": "true",
	\		"AfterUnion": "true",
	\		"BeforeCatch": "true",
	\		"BeforeElse": "true",
	\		"IndentBraces": "false" },
	\	"BreakBeforeBraces": "Custom",
	\	"BreakConstructorInitializers": "BeforeComma",
	\	"ColumnLimit": 0,
	\	"Cpp11BracedListStyle": "true",
	\	"IncludeBlocks": "Preserve",
	\	"IndentWidth": 4,
	\	"IndentCaseLabels": "true",
	\	"IndentWrappedFunctionNames": "false",
	\	"MaxEmptyLinesToKeep": 1,
	\	"NamespaceIndentation": "None",
	\	"PointerAlignment": "Left",
	\	"SortIncludes": "false",
	\	"SpaceBeforeParens": "Never",
	\	"SpacesInAngles": "false",
	\	"SpacesInContainerLiterals": "false",
	\	"SpacesInParentheses": "false",
	\	"SpacesInSquareBrackets": "false",
	\	"SortUsingDeclarations": "false",
	\	"Standard": "Cpp11",
	\	"TabWidth": 4,
	\	"UseTab": "Never"
	\ }
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" }}}
call plug#end() " end of plugin installation {{{
" }}}

" shortcuts: fast split/window navigation with <Ctrl-hjkl> {{{
nnoremap <C-h> <C-w><C-h>
inoremap <C-h> <C-o><C-w><C-h>
tnoremap <C-h> <C-\><C-n><C-w>h
nnoremap <C-j> <C-w><C-j>
inoremap <C-j> <C-o><C-w><C-j>
tnoremap <C-j> <C-\><C-n><C-w>j
nnoremap <C-k> <C-w><C-k>
inoremap <C-k> <C-o><C-w><C-k>
tnoremap <C-k> <C-\><C-n><C-w>k
nnoremap <C-l> <C-w><C-l>
inoremap <C-l> <C-o><C-w><C-l>
tnoremap <C-l> <C-\><C-n><C-w>l
" }}}
" shortcuts: return to normal mode in terminal window {{{
tnoremap <C-j><C-k> <C-\><C-n>
tnoremap <Esc> <C-\><C-n>
" one exception: <Esc> should close fzf terminal window
autocmd! FileType fzf tnoremap <buffer> <Esc> <c-c>
" }}}
" shortcuts: create new split/tab window {{{
nnoremap <leader>bh :new<CR>
nnoremap <leader>bv :vnew<CR>
" }}}
" shortcuts: working with tabs {{{
nnoremap <leader>tc	:tabclose<CR>
nnoremap <leader>tm	:tabmove
nnoremap <leader>tn	:tabnew<CR>
nnoremap <leader>to	:tabonly<CR>
nnoremap <leader>l	:tabnext<CR>
nnoremap <leader>h	:tabprevious<CR>
" }}}
" shortcuts: scrolling in buffers {{{
nnoremap <leader>n <PageDown>
nnoremap <leader>p <PageUp>
" scroll one half page up/down
nnoremap <leader>k <C-u>
nnoremap <leader>j <C-d>
" }}}
" shortcuts: exit a session {{{
nnoremap <leader>q :qa<CR>
nnoremap <leader>w :conf wqa<CR>
" }}}
" shortcuts: toggle whitespaces {{{
nnoremap <leader>7 :set list!<CR>
" }}}
" shortcuts: stop highlighting {{{
nnoremap <leader><CR> :nohlsearch<CR>
" }}}
" shortcuts: set CWD to folder of the open buffer {{{
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
" }}}
" shortcuts: searching in files {{{
" Keep search results in the center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

vnoremap <silent> * :<C-u>call s:visual_selection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call s:visual_selection('', '')<CR>?<C-R>=@/<CR><CR>
" }}}

" configuration: indentation & whitespaces {{{
filetype plugin indent on	" indentation based on file type
set tabstop=4				" number of spaces tab is counted for
set softtabstop=0			" cause <BS> key to delete correct number of spaces
set shiftwidth=4			" number of spaces to use for auto indent
set listchars+=space:·,trail:·,tab:»·,eol:¶
" }}}
" configuration: highlighting & searching in files {{{
set number			" show line numbers
set relativenumber	" show line numbers relative to cursor position
set cursorline		" mark current line
set showmatch		" show matching brackets
set colorcolumn=91	" position of vertical line
set hlsearch		" highlight search results
set ignorecase		" case insensitive search
set smartcase		" case sensitive only if search contains uppercase letter
" }}}
" configuration: user interface {{{
set mouse=a		" use mouse
set showcmd		" show incomplete commands in the bottom right corner
" opening new splits
set splitbelow	" put new split windows to the bottom of the current
set splitright	" put new vsplit windows to the right of the current
set foldmethod=marker
" scrolling
set scrolloff=1	" minimum number of lines to show above and below the cursor
" line wrapping options
set nowrap		" never wrap lines
" }}}
" configuration: spell checker {{{
set spell			" uses English language by default
set spelllang=en_us	" change default language of spell checker
" }}}
" configuration: save undo history {{{
if has("persistent_undo")
	set undofile
	set undodir=~/.config/nvim/undodir
endif
" }}}
" configuration: backups {{{
set noswapfile
" }}}
" configuration: netrw {{{
let g:netrw_banner = 0		" do not show banner
let g:netrw_winsize = 20	" width of netrw window (% from width of current window)
let g:netrw_liststyle = 3	" list entries in tree like style
" }}}
" configuration: adjust file type specific options {{{
if has("autocmd")
	" delete trailing whitespaces before saving files
	autocmd BufWritePre * call s:strip_trailing_whitespaces()
	" use tabs instead spaces for c & cpp filetypes
	autocmd FileType c,cpp autocmd BufEnter
				\ <buffer> setlocal expandtab foldmethod=indent
endif
" }}}
" apply colorscheme {{{
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" Needs vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
	set termguicolors
endif
"
let g:onedark_termcolors = 256
execute 'colorscheme ' s:color_scheme
" }}}

packloadall				" load all plugins
silent! helptags ALL	" load help files for all plugins

