function! g:IsInstalled(...)
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! VisualSelection(direction, extra_filter) range
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
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! DeleteTrailingWhiteSpace()
    let l:save_cursor = getpos(".")
    let l:old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', l:save_cursor)
    call setreg('/', l:old_query)
endfunction
