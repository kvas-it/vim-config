" Use Vim settings, rather then Vi settings (much better!).
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set visualbell          " less annoying
set nobackup		" don't keep a backup file
set history=100		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set number		" number lines
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase          " ignore case when searching
set hidden		" allow hidden unsaved buffers
set colorcolumn=80      " show maximal line length aid

" use Q for formatting
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
Plugin 'sjl/gundo.vim'
Plugin 'groenewege/vim-less'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-commentary'
Plugin 'vim-scripts/vcscommand.vim'
Plugin 'dag/vim2hs'
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mhinz/vim-signify'
Plugin 'scrooloose/nerdtree'
Plugin 'mitsuhiko/vim-jinja'
Plugin 'dag/vim-fish'
Plugin 'rust-lang/rust.vim'
Plugin 'w0rp/ale'
Plugin 'chrisbra/vim-diff-enhanced'
Plugin 'jremmen/vim-ripgrep'

" Snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

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
  colorscheme jellybeans
endif

" Set font for gui vim.
if has("gui_running")
  set guifont=Source\ Code\ Pro\ Medium:h11
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

" commands for configuring indenting
command! TW4 setlocal sw=4 sts=4 et
command! TW2 setlocal sw=2 sts=2 et
command! TT8 setlocal sw=8 sts=8 noet
command! TT4 setlocal sw=4 sts=4 noet

" Put autocmds in an autocmd group, so that we can delete them easily.
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

" configure indent size based on language
au FileType python TW4
au FileType haskell TW4
au FileType ruby TW4
au FileType cpp TW2
au FileType javascript TW2
au FileType coffee TW2
au FileType html TW2
au FileType xml TW2
au FileType rst TW2
au FileType yaml TW2
au FileType markdown TW2

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

" ALE configuration
let g:ale_sign_error = '!'
let g:ale_sign_warning = '?'
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_set_loclist = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_linters = {'rust': ['cargo']}

" folding
set foldmethod=indent
set nofoldenable
set foldlevel=1

" Configure the clipboard depending on the OS
if has('macunix')
  set clipboard=unnamed   	" use primary OS clipboard
else
  set clipboard=unnamedplus	" use X Window CLIPBOARD clipboard
endif

" Paste toggle
set pastetoggle=<F2>

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
    if has('nvim')
      execute 'sp term://' . g:run_cmd . ' ' . g:run_target
    else
      execute ':!' . g:run_cmd . ' ' . g:run_target
    endif
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

" map '\n'/'\p' to :cnext/:cprev and '\c' to open quickfix list.
map <leader>n :cnext<CR>
map <leader>p :cprev<CR>
map <leader>c :copen<CR>

" map '\N'/'\P' to :lnext/:lprev and '\l' to open location list.
map <leader>N :lnext<CR>
map <leader>P :lprev<CR>
map <leader>l :lopen<CR>

" ctrl+p config
let g:ctrlp_cmd = 'CtrlPMixed'
map <leader>e :CtrlP
set wildignore+=doc/*,node_modules/*,*.html

" Number addition and subtraction (because <C-a> is used by tmux)
map <leader>a <C-a>
" Since we defined \a for addition, \x for subtraction would be consistent
map <leader>x <C-x>

" Signify configuration
map <leader>s :SignifyToggle<CR>
map <leader>S :SignifyRefresh<CR>

" RipGrep key binding (\g)
map <leader>g :Rg 

" Diff config
map <leader>d :windo diffthis<CR>
map <leader>D :windo diffoff<CR>

" NeoVim-specific stuff
if has('nvim')
  set wildmenu
  set wildmode=longest,list
  " Exit from insert mode in the terminal window.
  tnoremap <Esc> <C-\><C-n>
  " Send <Esc> to inside of the terminal (handy if you run another vim there).
  tnoremap <leader><Esc> <Esc>
  " Open shell
  command! Bash e term://bash
endif
