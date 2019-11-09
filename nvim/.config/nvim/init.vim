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

func! s:strip_trailing_whitespaces()
	let l:blacklist = ['markdown']
	if index(l:blacklist, &ft) < 0
		%s/\s\+$//e
	endif
endfunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:save_restore_view()
	let l:blacklist=[]

	if &l:diff | return 0 | endif
	if &buftype != '' | return 0 | endif
	if expand('%') =~ '\[.*\]' | return 0 | endif
	if empty(glob(expand('%:p'))) | return 0 | endif
	if &modifiable == 0 | return 0 | endif
	if len($TEMP) && expand('%:p:h') == $TEMP | return 0 | endif
	if len($TMP) && expand('%:p:h') == $TMP | return 0 | endif

	let l:file_name = expand('%:p')
	for l:ifile2skip in l:blacklist
		if l:file_name =~ l:ifile2skip
			return 0
		endif
	endfor

	return 1
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
			\			[ 'gitbranch', 'readonly', 'filename', 'modified', 'char2hex' ],
			\			[ 'gutentags' ] ],
			\ },
			\ 'component': {
			\	'char2hex': '0x%B'
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
let g:fzf_layout = { 'down': '~35%' }
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
let g:fzf_commits_log_options = '--graph --color=always
			\ --format="%C(yellow)%h%C(red)%d%C(reset)
			\ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

func! s:fzf_env_set()
	if executable('ag')
		let $FZF_DEFAULT_COMMAND='ag --depth -1 --hidden --ignore .git -l -g ""'
		if executable('bat')
			let $FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'
						\ --bind ctrl-f:page-down,ctrl-b:page-up"
		else
			let $FZF_DEFAULT_OPTS="--preview 'cat {}'"
		endif
	else
		echoerr 'Utility [ag] is not available. Please set it up!'
	endif
endfunc

func! s:fzf_env_reset()
	let $FZF_DEFAULT_OPTS=''
	let $FZF_DEFAULT_COMMAND=''
endfunc

func! s:fzf_search_colors()
	call <SID>fzf_env_reset()
	:Colors
endfunc

func! s:fzf_search_file_names()
	call <SID>fzf_env_set()
	:Files
endfunc

func! s:fzf_search_file_buffers()
	call <SID>fzf_env_reset()
	:Buffers
endfunc

func! s:fzf_search_file_buffer_lines()
	call <SID>fzf_env_reset()
	:BLines
endfunc

func! s:fzf_search_file_content()
	call <SID>fzf_env_reset()
	:Ag
endfunc

func! s:fzf_search_file_types()
	call <SID>fzf_env_reset()
	:Filetypes<CR>
endfunc

func! s:fzf_search_git_commits()
	call <SID>fzf_env_reset()
	:Commits
endfunc

func! s:fzf_search_git_commits_buffer()
	call <SID>fzf_env_reset()
	:BCommits
endfunc

func! s:fzf_search_history_files()
	call <SID>fzf_env_set()
	:History
endfunc

func! s:fzf_search_history_commands()
	call <SID>fzf_env_reset()
	:History:
endfunc

func! s:fzf_search_key_mappings()
	call <SID>fzf_env_reset()
	:Maps
endfunc

func! s:fzf_search_tags()
	call <SID>fzf_env_reset()
	call fzf#vim#tags(expand('<cword>'))
endfunc

nnoremap <leader>fa :call <SID>fzf_search_file_content()<CR>
nnoremap <leader>fb :call <SID>fzf_search_file_buffers()<CR>
nnoremap <leader>fc :call <SID>fzf_search_colors()<CR>
nnoremap <leader>ff :call <SID>fzf_search_file_names()<CR>
nnoremap <leader>fg :call <SID>fzf_search_git_commits()<CR>
nnoremap <leader>fh :call <SID>fzf_search_history_files()<CR>
nnoremap <leader>fi :call <SID>fzf_search_git_commits_buffer()<CR>
nnoremap <leader>fl :call <SID>fzf_search_file_buffer_lines()<CR>
nnoremap <leader>fm :call <SID>fzf_search_key_mappings()<CR>
nnoremap <leader>fq :call <SID>fzf_search_history_commands()<CR>
nnoremap <leader>fs :Snippets<CR>
nnoremap <leader>ft :call <SID>fzf_search_tags()<CR>
" use preview when FzFiles runs in fullscreen
command! -nargs=? -bang -complete=dir FzfFiles
			\ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:65%') : {}, <bang>0)
nnoremap <leader>fv :FzfFiles!<CR>
nnoremap <leader>fy :call <SID>fzf_search_file_types()<CR>
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

Plug 'Chiel92/vim-autoformat'
nnoremap <leader>0 :Autoformat<CR>
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
" shortcuts: indentation & white space characters {{{
nnoremap <leader>7 :set list!<CR>
nnoremap <leader><TAB> :%retab!<CR>
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
" }}}

" configuration: indentation & white space characters {{{
filetype plugin indent on	" indentation based on file type
set tabstop=4				" number of spaces tab is counted for
set softtabstop=0			" cause <BS> key to delete correct number of spaces
set shiftwidth=4			" number of spaces to use for auto indent
set listchars+=eol:¶,extends:⇒,precedes:⇐,space:·,tab:»·,trail:·
set list					" show whitespaces by default
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
" configuration: backup & undo history {{{
set noswapfile
if has("persistent_undo")
	set undofile
	set undodir=~/.config/nvim/undodir
endif
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

	autocmd FileType c,cpp,idl autocmd BufEnter
				\ <buffer> setlocal expandtab foldmethod=syntax
endif
" }}}
" configuration: save/restore view {{{
augroup RememberViews
	autocmd!
	" automatically save/restore views
	autocmd BufWritePre,BufWinLeave ?* if s:save_restore_view() | silent! mkview | endif
	autocmd BufWinEnter ?* if s:save_restore_view() | silent! loadview | endif
augroup END
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

nnoremap K :vert help <C-R><C-W><CR>
