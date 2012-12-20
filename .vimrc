" Basics {
set nocompatible " get out of horrible vi-compatible mode
set background=dark " we are using a dark background
set t_Co=16 " color numbers
syntax on " syntax highlighting on
filetype plugin indent on " load filetype plugins and indent settings

if has("gui_running")
	colorscheme desert
	set guifont=Ubuntu\ Mono\ 13
else
    colorscheme default
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

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
"autocmd VimEnter * TlistOpen
"autocmd VimEnter * wincmd p
let NERDTreeIgnore=['\.pyc', '\~$', '\.git', '\.hg', '\.svn', '\.dsp', '\.opt', '\.plg', '\.pdf']

" General {
set history=1000 " How many lines of history to remember
set clipboard+=unnamed " turns out I do like is sharing windows clipboard
set fileformats=unix,dos,mac " support all three, in this order
set viminfo+=! " make sure it can save viminfo
set iskeyword+=_,$,@,%,# " none of these should be word dividers, so make them not be
set nostartofline " leave my cursor where it was
" }

" Files/Backups {
set sessionoptions+=globals " What should be saved during sessions being saved
set sessionoptions+=localoptions " What should be saved during sessions being saved
set sessionoptions+=resize " What should be saved during sessions being saved
set sessionoptions+=winpos " What should be saved during sessions being saved
" }

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

" highlight the cursor current line in current window
autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine ctermbg=darkgrey cterm=bold
highlight LineNr ctermbg=darkgrey ctermfg=grey " line number bg and fg schema
"
set list listchars=tab:\ \ ,trail:·,eol:¬ " mark trailing white space
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
set softtabstop=4 " unify
set shiftwidth=4 " unify
set tabstop=4 " real tabs should be 4, but they will show with set list on
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
set foldenable			" Turn on folding
""set foldmarker={,}		" Fold C style code (only use this as default if you use a high foldlevel)
""set foldcolumn=4		" Give 1 column for fold markers
"""set foldopen-=search	" don't open folds when you search into them
"""set foldopen-=undo		" don't open folds when you undo stuff
set foldmethod=indent " Fold on the marker
set foldnestmax=2
set foldlevel=1000 " Don't autofold anything (but I can still fold manually)
let Tlist_Enable_Fold_Column = 0 " dont't give fold column to Tlist window
" }


" TagList open window {
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
" }

" SuperTab
let g:SuperTabDefaultCompletionType = "<C-x><C-o>"
"let g:SuperTabDefaultCompletionType = "context"

" Mappings {

" Count number of matches
noremap ,c :%s///gn<CR>

" Switch window
noremap <silent> <C-k> <C-W>k
noremap <silent> <C-j> <C-W>j
noremap <silent> <C-h> <C-W>h
noremap <silent> <C-l> <C-W>l

" NERDTree and TagList
noremap <F3> :NERDTreeToggle<CR>
noremap <F4> :Tlist<CR>

" Indent
noremap <F8> gg=G
inoremap <F8> <ESC>mzgg=G`z<Insert>

" Tab navigation
noremap <C-Right> :tabn<CR>
inoremap <C-Right> <esc>:tabn<CR><Insert>
noremap <C-Left> :tabprev<CR>
inoremap <C-Left> <ESC>tabprev<CR><Insert>
" }

" Automatically quit vim if NERDTree and Tlist are the last and only buffers
function NoExcitingBuffersLeft()
	" if NERDTree and Tlist both left
	"if tabpagenr("$") == 1 && winnr("$") == 2 && exists("t:NERDTreeBufName")
	if winnr("$") == 2 && exists("t:NERDTreeBufName")
		let window1 = bufname(winbufnr(1))
		let window2 = bufname(winbufnr(2))
		if (window1 == t:NERDTreeBufName || window1 == "__Tag_List__") && (window2 == t:NERDTreeBufName || window2 == "__Tag_List__")
			q
		endif
	endif
    " if only NERDTree left
    if winnr("$") == 1 && exists("b:NERDTreeType")
    	q
    endif
endfunction
"
autocmd bufenter * call NoExcitingBuffersLeft()

function LoadDjangoGoodies()

	" Django customization
	" it only works if we are at base of django site
	if filewritable('settings.py')

		" set DJANGO_SETTINGS_MODULE
		let $DJANGO_SETTINGS_MODULE=split( getcwd(),'/')[-1].".settings"
		" set right type of file, python.django for .py files,
		" htmldjango.django_template.xhtml or htmldjango.django_template.html
		" for html files. This bigname for html ft is to use both syntax of
		" Dave Hodder and SnipMate of Michael Sanders (and xhtml/html goodies
		" too)
		let l:escapefromhere=0
    	if &ft=="python"
			set ft=python.django
		elseif &ft=="html" || &ft=="xhtml"
			set ft=htmldjango.html
		else
			let l:escapefromhere=1
		endif

		if l:escapefromhere == 0
			" Set python path on enviroment, vim and python
			" if we are at /www/mysite/ we add to path /www and /www/mysite
			" so can complete mysite.
			let $PYTHONPATH .= ":/".join(split( getcwd(),'/')[0:-2],'/')."/:/".join(split( getcwd(),'/')[0:-1],'/')."/"
			"
			" If we are in a virtualenv
			python << EOF
import os, sys, vim
vir_env = os.environ.get('VIRTUAL_ENV', '')
if vir_env:
	act_this = os.path.join(vir_env, 'bin/activate_this.py')
	execfile(act_this, dict(__file__=act_this))
EOF

		endif
	endif
endfunction


" Python customization {
function LoadPythonGoodies()

	if &ft=="python"||&ft=="html"||&ft=="xhtml"

		" settings for django, for something unknow we need to call before python
		" path set
		call LoadDjangoGoodies()

		" set python path to vim
    	python << EOF
import os, sys, vim

for p in sys.path:
    if os.path.isdir(p):
		vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

		" some nice adjustaments to show errors
    	syn match pythonError "^\s*def\s\+\w\+(.*)\s*$" display 
		syn match pythonError "^\s*class\s\+\w\+(.*)\s*$" display 
		syn match pythonError "^\s*for\s.*[^:]\s*$" display 
		syn match pythonError "^\s*except\s*$" display 
		syn match pythonError "^\s*finally\s*$" display 
		syn match pythonError "^\s*try\s*$" display 
		syn match pythonError "^\s*else\s*$" display 
		syn match pythonError "^\s*else\s*[^:].*" display 
		"syn match pythonError "^\s*if\s.*[^\:]$" display 
		syn match pythonError "^\s*except\s.*[^\:]$" display 
		syn match pythonError "[;]$" display 
		syn keyword pythonError         do  

    	let python_highlight_builtins = 1
    	let python_highlight_exceptions = 1
    	let python_highlight_string_formatting = 1
    	let python_highlight_string_format = 1
    	let python_highlight_string_templates = 1
    	let python_highlight_indent_errors = 1
    	let python_highlight_space_errors = 1
    	let python_highlight_doctests = 1

		set ai tw=0 ts=4 sts=4 sw=4 et
	
	endif

endfunction

if !exists("myautocmds")
	let g:myautocmds=1

	"call LoadPythonGoodies()
	"autocmd Filetype python,html,xhtml call LoadPythonGoodies()
	au BufNewFile,BufRead *.py,*.html call LoadPythonGoodies()

	" Omni completion
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
	" Dissmiss PyDoc preview
	autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
	autocmd InsertLeave * if pumvisible() == 0|pclose|endif
endif
