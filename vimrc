
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

if has('mouse_sgr')
  set ttymouse=sgr
endif

" This is needed before Vundle init.
filetype off

" Initialize Vundle
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" Vundle managed plugins:
Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'scrooloose/syntastic'
Plugin 'sjl/gundo.vim'
Plugin 'groenewege/vim-less'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mileszs/ack.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-commentary'
Plugin 'vim-scripts/vcscommand.vim'
Plugin 'dag/vim2hs'
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mhinz/vim-signify'
Plugin 'scrooloose/nerdtree'

" Finalize Vundle init
call vundle#end()

" Airline configuration
let g:airline_powerline_fonts = 1
set laststatus=2

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  set t_Co=256
  syntax on
  set hlsearch
endif

if has("gui_running")
  set guifont=Source\ Code\ Pro\ Light:h12
  set go-=l
  set go-=r
  set go-=L
  set go-=R
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!

" For all text files set 'textwidth' to 72 characters.
autocmd FileType text setlocal textwidth=72

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
let g:netrw_list_hide='\.pyc$,\..*\.swp$,^\.hg'

" 2-space indents for C++ (according to Google style guide)
au FileType cpp setlocal sw=2 sts=2 et

" 4-space indents for python and javascript
au FileType python setlocal sw=4 sts=4 et
au FileType haskell setlocal sw=4 sts=4 et
au FileType ruby setlocal sw=4 sts=4 et
au FileType javascript setlocal sw=4 sts=4 et
au FileType coffee setlocal sw=2 sts=2 et

" commands for configuring indenting
command! TW4 setlocal sw=4 sts=4 et
command! TW2 setlocal sw=2 sts=2 et

" type :make and get a list of syntax errors
au FileType python setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
au FileType python setlocal equalprg=reindent.py
" au FileType python setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
au FileType python setlocal efm=\(\'%m\'\,\ \(\'%f\'\,\ %l\,\ %c\,\ \'%s\'\)\)

" 2-space indents for html, xml, rst and yaml
au FileType html setlocal sw=2 sts=2 et
au FileType xml setlocal sw=2 sts=2 et
au FileType rst setlocal sw=2 sts=2 et
au FileType yaml setlocal sw=2 sts=2 et

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
map <leader>\ :e %:h<CR>
map <leader>u :GundoToggle<CR>

let g:NERDTreeHijackNetrw = 1
let g:NERDTreeIgnore=['\.pyc$']

" command and function to run python scripts
command! -complete=file -nargs=? Run call Run(<q-args>)
function! Run(...)
  if a:0 > 0 && a:1 != ''
    let g:run_target=a:1
  endif
  if exists('g:run_target')
    wa
    execute ':!' . g:run_cmd . ' ' . g:run_target
  else
    Run %:p
  endif
endfunction

" Formatting xml
command! XMLFormat % !xmllint --format -

" External command used to run files (vimrun delegates to an appropriate
" test runner, etc.).
let g:run_cmd = 'vimrun'

" run current file
map <leader>R :wa<CR>:Run %:p<CR>
" run last file
map <leader>r :wa<CR>:Run<CR>

" Code checking with Syntastic
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_javascript_checkers = ['jshint', 'jscs']
let g:syntastic_python_checkers = ['flake8']
function! SyntasticShowErr()
  execute ':Errors'
  command! SyntasticToggleErr call SyntasticHideErr()
endfunction
function! SyntasticHideErr()
  execute ':SyntasticReset'
  execute ':SyntasticCheck'
  command! SyntasticToggleErr call SyntasticShowErr()
endfunction
command! SyntasticToggleErr call SyntasticShowErr()

let g:syntastic_always_populate_loc_list = 1
map <leader>f :SyntasticToggleErr<CR>
map <leader>F :SyntasticToggleMode<CR>
map <leader>N :lnext<CR>
map <leader>P :lprev<CR>

" map '\n'/'\p' to :cnext/:cprev
map <leader>n :cnext<CR>
map <leader>p :cprev<CR>

" ctrl+p config
let g:ctrlp_cmd = 'CtrlPMixed'
map <leader>e :CtrlP
set wildignore+=doc/*,node_modules/*,*.html

" Number addition and subtraction (because <C-a> is used by screen)
map <leader>a <C-a>
" Since we defined \a for addition, \x for subtraction would be consistent
map <leader>x <C-x>

" Signify toggle
map <leader>s :SignifyToggle<CR>

" Grep binding (\g)
map <leader>g :grep -r
