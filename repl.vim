" Support for using a clojure Repl

function! s:go_to_repl()
    let g:window_before_repl = winnr()
    for n in range(1, winnr('$'))
        let name = bufname(winbufnr(n))
        if name =~ 'term:.*:clj'
            execute n 'wincmd w'
            break
        endif
    endfor
endfunction

function! s:return_from_repl()
    execute g:window_before_repl 'wincmd w'
endfunction

function! s:toggle_repl()
    if exists('g:window_before_repl')
        call s:return_from_repl()
        unlet g:window_before_repl
    else
        call s:go_to_repl()
    endif
endfunction

function! s:paste_to_repl()
    let cur_win = winnr()
    for n in range(1, winnr('$'))
        let name = bufname(winbufnr(n))
        if name =~ 'term:.*:clj'
            execute n 'wincmd w'
            execute 'normal! p'
            execute "put ='\<cr>'"
            execute cur_win 'wincmd w'
            break
        endif
    endfor
endfunction

command! ReplPaste call s:paste_to_repl()
command! ReplGo call s:go_to_repl()
command! ReplToggle call s:toggle_repl()
command! ReplReturn call s:return_from_repl()
