
" Use Vim settings, rather then Vi settings (much better!).
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		" don't keep a backup file
set history=100		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set number		" number lines
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hidden		" allow hidden unsaved buffers

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$") |
\   exe "normal! g`\"" |
\ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" exclude the files that we never edit
set wildignore+=*.pyc
let g:netrw_list_hide='\.pyc$,\..*\.swp$'

" 4-space indents for python and javascript
au FileType python setlocal sw=4 sts=4 et
au FileType javascript setlocal sw=4 sts=4 et

" type :make and get a list of syntax errors
au FileType python setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
au FileType python setlocal equalprg=reindent.py
" au FileType python setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
au FileType python setlocal efm=\(\'%m\'\,\ \(\'%f\'\,\ %l\,\ %c\,\ \'%s\'\)\)

" 2-space indents for html and xml
au FileType html setlocal sw=2 sts=2 et
au FileType xml setlocal sw=2 sts=2 et

" zpt is html too
au BufRead,BufNewFile *.zpt setfiletype html
" pys is python too
au BufRead,BufNewFile *.pys setfiletype python

" folding
set foldmethod=indent
set nofoldenable
set foldlevel=1

" use OS clipboard
set clipboard=unnamed

" map ctrl+hjkl to move between windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

map <leader>b :VCSBlame<CR>
map <leader>d :VCSDiff<CR>
map <leader>\ :Ex<CR>
map <leader>u :GundoToggle<CR>

" command and function to run python scripts
command! -complete=file -nargs=? PRun call PRun(<q-args>)
function! PRun(...)
	if a:0 > 0 && a:1 != ''
		let g:prun_target=a:1
	endif
	if exists('g:prun_target')
		wa
		execute ':!' . g:prun_cmd . ' ' . g:prun_target
	else
		PRun %:p
	endif
endfunction

" formatting xml
command! XMLFormat % !xmllint --format -

" external command used to run python scripts
" let g:prun_cmd = 'python'
" or use this for running under Zope
let g:prun_cmd = 'zrun'

" run current file in zope environment
map <leader>R :wa<CR>:PRun %:p<CR>
" run last file
map <leader>r :wa<CR>:PRun<CR>

" Code checking with flake8 and Khuno
map <leader>f :call Flake8()<CR>
map <leader>F :Khuno show<CR>

" Highlighting of errors (Khuno)
hi clear SpellBad
hi SpellBad cterm=underline

" map '\n'/'\p' to :cnext/:cprev
map <leader>n :cnext<CR>
map <leader>p :cprev<CR>

" ctrl+p config
let g:ctrlp_cmd = 'CtrlPMixed'
map <leader>e :CtrlP 

" Number addition and subtraction (because <C-a> is used by screen)
map <leader>a <C-a> 
" Since we defined \a for addition, \x for subtraction would be consistent
map <leader>x <C-x> 

" Ack (called with \g for _grep_)
map <leader>g :Ack 
" And real grep
map <leader>G :grep -r 

" Ctags
:set tags=~/.mytags

" activate pathogen
call pathogen#infect()

