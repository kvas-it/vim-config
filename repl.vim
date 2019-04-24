" Support for using a clojure Repl

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

command! PasteToRepl call s:paste_to_repl()

map <leader>x y%:PasteToRepl<cr>
