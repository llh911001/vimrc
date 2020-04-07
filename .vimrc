" Use vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}

Plug 'Shougo/denite.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'

Plug 'kkoomen/vim-doge'
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

" Themes
Plug 'joshdick/onedark.vim'
"Plug 'kristijanhusak/vim-hybrid-material'
"Plug 'srcery-colors/srcery-vim'
"Plug 'sainnhe/edge'
"Plug 'chriskempson/base16-vim'
"Plug 'kaicataldo/material.vim'

" Initialize plugin system
call plug#end()

syntax enable
set termguicolors
set background=dark

colorscheme onedark
"colorscheme hybrid_reverse
"colorscheme srcery
"colorscheme edge
"colorscheme base16-oceanicnext
"let g:material_terminal_italics=1
"let g:material_theme_style='darker'
"colorscheme material

set encoding=utf-8
let mapleader=","

" NERDTree {
noremap <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.git', 'node_modules']

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
" Automatically quit vim if NERDTree and tagbar are the last and only buffers
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }

" coc.nvim {
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-css']

" use <tab> for trigger completion and navigate to next complete item
inoremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `kp` and `kn` for navigate diagnostics
nmap <silent> <Leader>kp <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>kn <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>kr <Plug>(coc-rename)
" }

" denite.vim {
call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('buffer', 'date_format', '')
call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '.git/', 'node_modules/', 'images/', '*.min.*', 'img/', 'fonts/', '*.png'])

let s:denite_options = {'default' : {
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}

function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)

nmap <C-p> :Denite -start-filter file/rec<CR>
nmap <Leader>b :Denite buffer<CR>
nnoremap \ :Denite grep<CR>

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <Esc>
  \ <Plug>(denite_filter_quit)
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction
" }

" vim-doge {
" generate jsdoc for function under cursor
let g:doge_mapping='<Leader>d'
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

" Cursor
let &t_SI="\<Esc>]50;CursorShape=1\x7"
let &t_SR="\<Esc>]50;CursorShape=2\x7"
let &t_EI="\<Esc>]50;CursorShape=0\x7"

" Remove trailing spaces
function! TrimTrailingSpaces()
    %s/\s\+$//e
endfunction

" General settings {
set updatetime=300
set history=1000 " lines of history to remember
set clipboard+=unnamed " share with system clipboard
set viminfo+=! " make sure it can save viminfo
set report=0 " report when anything changed via :...
set noerrorbells " don't make noise
" }

" UI {
set printoptions+=syntax:y " syntax when printing
set linespace=0 " space it out a little more (easier to read)
set wildmenu " turn on wild menu
set wildmode=list:longest " turn on wild menu in special format (long format)
set wildignore=*.pyc,*.pyo,*.dll,*.o,*.obj,*.exe,*.swo,*.swp,*.jpg,*.gif,*.png " ignore some formats,*.bak,
set number " turn on line numbers
set relativenumber
set numberwidth=4
set lazyredraw " do not redraw while running macros (much faster) (LazyRedraw)
set hidden " change buffer without saving
set backspace=indent,eol,start " make backspace work normal
set whichwrap+=<,>,[,],b,s  " backspace and cursor keys wrap to
"set mouse=a " use mouse everywhere

set showmatch " show matching brackets
set hlsearch
set incsearch " highlight as type
set scrolloff=5 " keep 5 lines (top/bottom) for scope
set sidescrolloff=5 " keep 5 lines at the side
set visualbell " blink instead beep
"set statusline=\ %f%m%r%h%w\ \|\ %2p%%\ %4v:%-4l/%4L%=%{coc#status()}\ 
set statusline=\ %f%m%r%h%w\ \|\ %p%%\ %v:%l/%L%=%{&ft}\ \|\ %{coc#status()}\ 
set laststatus=2 " always show the status line

" highlight the cursor current line in current window
autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine ctermbg=NONE cterm=NONE guibg=NONE
highlight CursorLineNr term=bold cterm=bold gui=bold

set list listchars=tab:→\ ,trail:· " mark tab and trailing white space
match ErrorMsg '\s\+$' " mark trailing spaces as error
" }

" Indent Related {
set nosmartindent " smartindent (filetype indenting instead)
set softtabstop=2 " unify
set shiftwidth=2 " unify
set tabstop=2 " unify
set expandtab " use spaces instead of tab
set smarttab " be smart when using tabs
set copyindent " follow existing lines indent
" }

" Text Formatting/Layout {
set shiftround " when at 3 spaces, and hit > ... go to 4, not 5
"set nowrap " do not wrap line
set preserveindent " follow existing lines
set ignorecase " case insensitive by default
set smartcase " if there are caps, go case-sensitive
set completeopt=menu,longest,preview " improve the way autocomplete works
" }

" Folding {
set foldmethod=indent   " fold on the marker
set foldlevel=1000 " don't autofold anything
" }

" Mappings {
noremap <Leader>t :call TrimTrailingSpaces()<CR>
noremap <Leader>c :%s///gn<CR>
noremap <Leader>a ^
noremap <Leader>e $
noremap <Leader>s :w<CR>
noremap <Leader>z :q<CR>
noremap <Leader>r :NERDTreeFind<CR>

noremap <Leader>/ :nohlsearch<CR>
" Delete current visual selection and dump in black hole buffer before pasting
vnoremap <Leader>p "_dP

" Switch window
noremap <silent> <C-k> <C-W>k
noremap <silent> <C-j> <C-W>j
noremap <silent> <C-h> <C-W>h
noremap <silent> <C-l> <C-W>l

" Tab navigation
noremap <Leader>h :tabn<CR>
inoremap <Leader>h <esc>:tabn<CR><Insert>
noremap <Leader>l :tabprev<CR>
inoremap <Leader>l <ESC>tabprev<CR><Insert>

" Allows you to save files you opened without write permissions via sudo
cmap w!! w !sudo tee %
" }
