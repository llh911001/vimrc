" Use vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'

Plug 'tpope/vim-fugitive'
Plug 'kkoomen/vim-doge'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" Themes
Plug 'patstockwell/vim-monokai-tasty'
"Plug 'joshdick/onedark.vim'

" Initialize plugin system
call plug#end()

syntax enable
set termguicolors
set background=dark

colorscheme vim-monokai-tasty
"colorscheme onedark
"colorscheme hybrid_reverse
"colorscheme srcery
"colorscheme edge
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
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-css', 'coc-prettier', 'coc-flutter', 'coc-word']

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

" Use `,j` and `,k` for navigate diagnostics
nmap <silent> <Leader>k <Plug>(coc-diagnostic-prev)
nmap <silent> <Leader>j <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>r <Plug>(coc-rename)

" coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <C-s> :Prettier<CR>
vmap <C-s> <Plug>(coc-format-selected)
" }

" fzf {
nmap <C-p> :Files<CR>
nmap <Leader>b :Buffers<CR>
nnoremap \ :Ag<CR>
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
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

" General settings {
set updatetime=300
set history=1000 " lines of history to remember
set clipboard+=unnamed " share with system clipboard
set viminfo+=! " make sure it can save viminfo
set report=0 " report when anything changed via :...
set noerrorbells " don't make noise
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

" UI {
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
set printoptions+=syntax:y " syntax when printing
"set mouse=a " use mouse everywhere

set showmatch " show matching brackets
set hlsearch
set incsearch " highlight as type
set scrolloff=5 " keep 5 lines (top/bottom) for scope
set sidescrolloff=5 " keep 5 lines at the side
set visualbell " blink instead beep
set laststatus=2 " always show the status line
"set statusline=%f%m%r%h%w\ %p%%\ %v:%l/%L%=%{&ft}\ %{coc#status()}\ 
set statusline=%f%m%r%h%w%{GitBranch()}%p%%\ %v:%l/%L%=%{&ft}\ %{coc#status()}\ 

function! GitBranch()
  let b:gitbranch=fugitive#head()
  return strlen(b:gitbranch) > 0?' ('.b:gitbranch.') ':' '
endfunction

" highlight the cursor current line in current window
autocmd WinEnter,BufEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine ctermbg=NONE cterm=NONE guibg=NONE
highlight CursorLineNr term=bold cterm=bold gui=bold

set list listchars=tab:→\ ,trail:· " mark tab and trailing white space
match ErrorMsg '\s\+$' " mark trailing spaces as error
" }

" Remove trailing spaces
function! TrimTrailingSpaces()
    %s/\s\+$//e
endfunction

" Mappings {
noremap <Leader>t :call TrimTrailingSpaces()<CR>
noremap <Leader>c :%s///gn<CR>
noremap <Leader>a ^
noremap <Leader>e $
noremap <Leader>s :w<CR>
noremap <Leader>z :q<CR>
noremap <Leader>g :e<CR>
noremap <Leader>f :NERDTreeFind<CR>

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
