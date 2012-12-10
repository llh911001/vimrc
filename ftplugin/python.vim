"source '~/.vim/ftplugin/py_jump.vim'
"source '~/.vim/ftplugin/python_fold.vim'

setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal smartindent


" VIM filetype plugin
" Language: Python source files
" Maintainer: Sergei Matusevich <motus@motus.kiev.ua>
" ICQ: 31114346 Yahoo: motus2
" http://motus.kiev.ua/motus2/Files/py_jump.vim
" Last Change: 2 November 2005
" Licence: Public Domain

" WHAT'S COOL: Use % command when editing python sources
" to jump to the end of the indented block and then back.
" If cursor is at the bracket character, % will take
" you to the matching bracket.

" INSTALLATION: rename this file to python.vim
" and copy it to your ~/.vim/ftplugin/ directory

"if exists("g:did_python_ftplugin")
"  finish
"endif

" Don't load another plugin (this is global)
"let g:did_python_ftplugin = 1

" This is the only tunable parameter of this script.
" It specifies timeout (in seconds) for the backward jump.
" That is, if you used % twice within this time frame,
" it will jump back, not forward, thus trying to guess
" correct indentation level. Try to use % several times
" to check it out.
let g:py_jump_timeout = 1

let s:py_jump_ts = 0

if !exists("*PyJump")

  function s:PySeekForward()
    let line    = line(".") + 1
    let lnEnd   = line("$")
    let iStart  = indent(".")
    while line <= lnEnd
      let iCurr = indent(line)
      if iCurr <= iStart && getline(line) !~ "^\\s\*$"
        let line = prevnonblank(line - 1)
        call cursor(line, indent(line) + 1)
        return
      endif
      let line = line + 1
    endwhile
    let line = prevnonblank("$")
    call cursor(line, indent(line) + 1)
  endfunction

  function s:PySeekBackward()
    let line    = prevnonblank(".")
    let iStart  = indent(line)
    while line > 0
      let iCurr = indent(line)
      if iCurr < iStart && getline(line) !~ "^\\s\*$"
        call cursor(line, indent(line) + 1)
        return 0
      endif
      let line = line - 1
    endwhile
    return 1
  endfunction

  function PyJump(vis_mode)
    let ch = getline(".")[col(".")-1]
    if ch != "," && ch != ":" && stridx(&matchpairs, ch) >= 0
      let s:py_jump_ts = 0
      unmap <buffer> %
      normal %
      nnoremap <buffer> % :call PyJump("")<Enter>
      vnoremap <buffer> % omao<Esc>:call PyJump(visualmode())<Enter>
    else
      let ts = localtime()
      let ts_fwd = ts - s:py_jump_ts >= g:py_jump_timeout
      let line = prevnonblank(".")
      let next = nextnonblank(line+1)
      if indent(line) < indent(next) && ts_fwd
        call s:PySeekForward()
      else
        if s:PySeekBackward()
          call s:PySeekForward()
        endif
      endif
      let s:py_jump_ts = ts
    endif
    if strlen(a:vis_mode)
      exec "normal " . a:vis_mode . "`ao"
    endif
  endfunction

endif

nnoremap <buffer> % :call PyJump("")<Enter>
vnoremap <buffer> % omao<Esc>:call PyJump(visualmode())<Enter>

" Vim folding file
" Language:	Python
" Author:	Jorrit Wiersma (foldexpr), Max Ischenko (foldtext), Robert
" Ames (line counts)
" Last Change:	2005 Jul 14
" Version:	2.3
" Bug fix:	Drexler Christopher, Tom Schumm, Geoff Gerrietts


setlocal foldmethod=expr
setlocal foldexpr=GetPythonFold(v:lnum)
setlocal foldtext=PythonFoldText()


function! PythonFoldText()
  let line = getline(v:foldstart)
  let nnum = nextnonblank(v:foldstart + 1)
  let nextline = getline(nnum)
  if nextline =~ '^\s\+"""$'
    let line = line . getline(nnum + 1)
  elseif nextline =~ '^\s\+"""'
    let line = line . ' ' . matchstr(nextline, '"""\zs.\{-}\ze\("""\)\?$')
  elseif nextline =~ '^\s\+"[^"]\+"$'
    let line = line . ' ' . matchstr(nextline, '"\zs.*\ze"')
  elseif nextline =~ '^\s\+pass\s*$'
    let line = line . ' pass'
  endif
  let size = 1 + v:foldend - v:foldstart
  if size < 10
    let size = " " . size
  endif
  if size < 100
    let size = " " . size
  endif
  if size < 1000
    let size = " " . size
  endif
  return size . " lines: " . line
endfunction


function! GetPythonFold(lnum)
    " Determine folding level in Python source
    "
    let line = getline(a:lnum)
    let ind  = indent(a:lnum)

    " Ignore blank lines
    if line =~ '^\s*$'
	return "="
    endif

    " Ignore triple quoted strings
    if line =~ "(\"\"\"|''')"
	return "="
    endif

    " Ignore continuation lines
    if line =~ '\\$'
	return '='
    endif

    " Support markers
    if line =~ '{{{'
	return "a1"
    elseif line =~ '}}}'
	return "s1"
    endif

    " Classes and functions get their own folds
    if line =~ '^\s*\(class\|def\)\s'
	return ">" . (ind / &sw + 1)
    endif

    let pnum = prevnonblank(a:lnum - 1)

    if pnum == 0
	" Hit start of file
	return 0
    endif

    " If the previous line has foldlevel zero, and we haven't increased
    " it, we should have foldlevel zero also
    if foldlevel(pnum) == 0
	return 0
    endif

    " The end of a fold is determined through a difference in indentation
    " between this line and the next.
    " So first look for next line
    let nnum = nextnonblank(a:lnum + 1)
    if nnum == 0
	return "="
    endif

    " First I check for some common cases where this algorithm would
    " otherwise fail. (This is all a hack)
    let nline = getline(nnum)
    if nline =~ '^\s*\(except\|else\|elif\)'
	return "="
    endif

    " Python programmers love their readable code, so they're usually
    " going to have blank lines at the ends of functions or classes
    " If the next line isn't blank, we probably don't need to end a fold
    if nnum == a:lnum + 1
	return "="
    endif

    " If next line has less indentation we end a fold.
    " This ends folds that aren't there a lot of the time, and this sometimes
    " confuses vim.  Luckily only rarely.
    let nind = indent(nnum)
    if nind < ind
	return "<" . (nind / &sw + 1)
    endif

    " If none of the above apply, keep the indentation
    return "="

endfunction

