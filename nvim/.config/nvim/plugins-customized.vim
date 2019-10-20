let s:plugins_base_dir=expand('~/.config/nvim/plugged/')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'lightline.vim')
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
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'vim-startify')
    let g:startify_session_autoload = 1     " load sessions automatically
    let g:startify_session_persistence = 1  " save sessions on exit
else
    echoerr 'Missing plugin [vim-startify]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'vim-polyglot')
    let g:cpp_class_scope_highlight = 1
    let g:cpp_member_variable_highlight = 1 " not sure if it has some effect
    let g:cpp_class_decl_highlight = 1
else
    echoerr 'Missing plugin [vim-polyglot]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'indentLine')
    let g:indentLine_char = '┊'
    let g:indentLine_conceallevel = 1
else
    echoerr 'Missing plugin [indentLine]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
if isdirectory(s:plugins_base_dir . 'vim-gutentags')
    let g:gutentags_cache_dir = '~/.cache/gutentags'
    let g:gutentags_project_root = ['.git/']        " '/' to ignore submodules
    let g:gutentags_add_default_project_roots = 0   " do not add any default project roots
    let g:gutentags_exclude_filetypes = ['log']

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
else
    echoerr 'Missing plugin [vim-gutenptags]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'vim-better-whitespace')
    let g:better_whitespace_enabled=1
    let g:strip_whitespace_on_save=1
    let g:strip_whitespace_confirm=0
else
    echoerr 'Missing plugin [vim-better-whitespace]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'ultisnips')
    " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger="<C-Space>"
    let g:UltiSnipsJumpForwardTrigger="<c-i>"
    let g:UltiSnipsJumpBackwardTrigger="<c-o>"
    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"
    let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
    let g:UltiSnipsSnippetDirectories=['UltiSnips']
else
    echoerr 'Missing plugin [ultisnips]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'YouCompleteMe')
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
    nnoremap <leader>4 :leftabove vertical YcmCompleter GoTo<CR>
    nnoremap <leader>5 :YcmForceCompileAndDiagnostics<CR>
    nnoremap <leader>6 :YcmCompleter GetType<CR>
    nnoremap <leader>9 :YcmCompleter FixIt<CR>
else
    echoerr 'Missing plugin [YouCompleteMe]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'fzf.vim')
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

    function! FzfSearchFileNames()
        let $FZF_DEFAULT_COMMAND = 'ag --depth -1 --hidden --ignore .git -l -g ""'
        let $FZF_DEFAULT_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'
                    \ --bind ctrl-f:page-down,ctrl-b:page-up"
        let $BAT_THEME="zenburn"
        :Files
    endfunction

    function! FzfSearchFileContent()
        let $FZF_DEFAULT_OPTS=''
        :Ag
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
    nnoremap <leader>ft :Tags<CR>
    " use preview when FzFiles runs in fullscreen
    command! -nargs=? -bang -complete=dir FzfFiles
                \ call fzf#vim#files(<q-args>, <bang>0 ? fzf#vim#with_preview('up:65%') : {}, <bang>0)
    command FzfChanges call s:fzf_changes()
    nnoremap <leader>fv :FzfFiles!<CR>
    nnoremap <leader>fy :Filetypes<CR>
    nnoremap <leader>fw :Windows<CR>
else
    echoerr 'Missing plugin [fzf.vim]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'vim-clang-format')
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

    autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
    autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
else
    echoerr 'Missing plugin [vim-clang-format]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'vim-fugitive')
    nnoremap <leader>gb :Gblame<CR>
    nnoremap <leader>gc :Gcommit -s -v<CR>
    nnoremap <leader>gd :Gvdiff<CR>
    nnoremap <leader>gl :Gpull<CR>
    nnoremap <leader>gp :Gpush --force-with-lease<CR>
    nnoremap <leader>gs :Gstatus<CR>
    nnoremap <leader>gw :Gwrite<CR>
else
    echoerr 'Missing plugin [vim-fugitive]!'
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if isdirectory(s:plugins_base_dir . 'tagbar')
    nnoremap <leader>8 :TagbarToggle<CR>
else
    echoerr 'Missing plugin [tagbar]!')
endif

