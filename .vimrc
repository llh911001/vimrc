" Basics {
set nocompatible " get out of horrible vi-compatible mode *Vundle required* filetype off " *Vundle required*

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'majutsushi/tagbar'
Plugin 'junegunn/vim-easy-align'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'Raimondi/delimitMate'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'groenewege/vim-less'
Plugin 'ap/vim-css-color'
Plugin 'easymotion/vim-easymotion'
Plugin 'matchit.zip'

call vundle#end()
filetype plugin indent on " load filetype plugins and indent settings; *Vundle required*
" end Vundle

set background=dark " we are using a dark background
set t_Co=256 " color numbers
set encoding=utf-8
syntax on " syntax highlighting on

if has("gui_running")
    colorscheme solarized
    set guifont=Monaco:h14
else
    colorscheme peachpuff
endif
" }

" When editing a file, always jump to the last cursor position
function! ResCur()
    if line("'\"") > 0 && line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END
" END of restore cursor

let NERDTreeIgnore=['\.pyc', '\~$', '\.git', '\.hg', '\.svn', '\.dsp', '\.opt', '\.plg', '\.pdf', 'node_modules']
let NERDTreeMouseMode=2 " Single click to activate directory

" Mark trailing spaces
match ErrorMsg '\s\+$'

" Cursor
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Remove trailing spaces
function! TrimTrailingSpaces()
    %s/\s\+$//e
endfunction

" General {
set history=1000 " How many lines of history to remember
set clipboard+=unnamed " turns out I do like is sharing windows clipboard
set fileformats=unix,dos,mac " support all three, in this order
set viminfo+=! " make sure it can save viminfo
set iskeyword+=_,$,@,%,# " none of these should be word dividers, so make them not be
set nostartofline " leave my cursor where it was
let mapleader=","
" }

" Files/Backups {
set sessionoptions+=globals " What should be saved during sessions being saved
set sessionoptions+=localoptions " What should be saved during sessions being saved
set sessionoptions+=resize " What should be saved during sessions being saved
set sessionoptions+=winpos " What should be saved during sessions being saved
" }
"
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

let g:syntastic_mode_map = {'mode': 'passive'}
let g:syntastic_javascript_checkers = ['standard']
let g:syntastic_html_checkers=['']
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
noremap <C-c> :SyntasticCheck<CR>

" Vim UI {
set popt+=syntax:y " Syntax when printing
set showcmd " show the command being typed
set linespace=0 " space it out a little more (easier to read)
set wildmenu " turn on wild menu
set wildmode=list:longest " turn on wild menu in special format (long format)
set wildignore=*.pyc,*.pyo,*.dll,*.o,*.obj,*.exe,*.swo,*.swp,*.jpg,*.gif,*.png " ignore some formats,*.bak,
set ruler " Always show current positions along the bottom
set cmdheight=1 " the command bar is 1 high
set number " turn on line numbers
set numberwidth=4 " If we have over 9999 lines, ohh, boo-hoo
set lazyredraw " do not redraw while running macros (much faster) (LazyRedraw)
set hidden " you can change buffer without saving
set backspace=2 " make backspace work normal
set whichwrap+=<,>,[,],h,l  " backspace and cursor keys wrap to
"set mouse=a " use mouse everywhere
"set shortmess=atI " shortens messages to avoid 'press a key' prompt
set report=0 " tell us when anything is changed via :...
set noerrorbells " don't make noise
set relativenumber

" highlight the cursor current line in current window
autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine ctermbg=black cterm=NONE
highlight LineNr ctermbg=darkgrey ctermfg=grey " line number bg and fg schema
"
set list listchars=tab:\ \ ,trail:· " mark trailing white space
" }

" Visual Cues {
set showmatch " show matching brackets
set matchtime=5 " how many tenths of a second to blink matching brackets for
set hlsearch
set incsearch " BUT do highlight as you type you search phrase
set scrolloff=5 " Keep 5 lines (top/bottom) for scope
set sidescrolloff=5 " Keep 5 lines at the size
"set novisualbell " don't blink
set vb " blink instead beep
set statusline=%f%m%r%h%w\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ENCODE=%{&fenc}]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2 " always show the status line
" }

" Indent Related {
set nosmartindent " smartindent (filetype indenting instead)
set autoindent " autoindent (should be overwrote by cindent or filetype indent)
set cindent " do c-style indenting
set softtabstop=2 " unify
set shiftwidth=2 " unify
set tabstop=2 " real tabs should be 4, but they will show with set list on
set expandtab " use spaces instead of tab
set smarttab " be smart when using tabs
set copyindent " but above all -- follow the conventions laid before us

" }

" Text Formatting/Layout {
"set formatoptions=tcrq " See Help (complex)
set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
set nowrap " do not wrap line
set preserveindent " but above all -- follow the conventions laid before us
set ignorecase " case insensitive by default
set smartcase " if there are caps, go case-sensitive
set completeopt=menu,longest,preview " improve the way autocomplete works
set nocursorcolumn " don't show the current column
" }

" Folding {
set foldenable        " Turn on folding
"set foldmarker={,}        " Fold C style code (only use this as default if you use a high foldlevel)
"set foldcolumn=4        " Give 1 column for fold markers
""set foldopen-=search    " don't open folds when you search into them
""set foldopen-=undo        " don't open folds when you undo stuff
set foldmethod=indent   " Fold on the marker
"set foldnestmax=2
set foldlevel=1000 " Don't autofold anything (but I can still fold manually)
""" }
""

" vim-jsx to work for .js files
let g:jsx_ext_required = 0

" SuperTab
let g:SuperTabDefaultCompletionType = "<C-x><C-o>"
let g:SuperTabDefaultCompletionType = "context"

" Mappings {
noremap <Leader>t :call TrimTrailingSpaces()<CR>
" Count number of matches
noremap <Leader>c :%s///gn<CR>
noremap <Leader>a ^
noremap <Leader>e $
noremap <Leader>s :w<CR>
noremap <Leader>z :q<CR>
noremap <Leader>r :NERDTreeFind<CR>

inoremap ' ''<ESC>i
inoremap " ""<ESC>i

noremap \ :Ag<Space>

" Switch window
noremap <silent> <C-k> <C-W>k
noremap <silent> <C-j> <C-W>j
noremap <silent> <C-h> <C-W>h
noremap <silent> <C-l> <C-W>l

" NERDTree and Tagbar
noremap <F3> :NERDTreeToggle<CR>
noremap <C-n> :NERDTreeToggle<CR>
noremap <F4> :TagbarToggle<CR>


" Tab navigation
noremap <Leader>h :tabn<CR>
inoremap <Leader>h <esc>:tabn<CR><Insert>
noremap <Leader>l :tabprev<CR>
inoremap <Leader>l <ESC>tabprev<CR><Insert>
" }

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
" Automatically quit vim if NERDTree and tagbar are the last and only buffers
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" let tagbar to be compact
let g:tagbar_compact = 1
