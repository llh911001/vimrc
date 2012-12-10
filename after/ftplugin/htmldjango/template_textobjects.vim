" textobj-htmldjango - Text objects for django templates
" Version: 0.1.0
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
" Dependencies:
"
"     textobj-user by Kana Natsuno
"     http://www.vim.org/scripts/script.php?script_id=2100
"
"     matchit by Benju Fisher
"     http://www.vim.org/scripts/script.php?script_id=39
"
"
" Overview:
"     This plugin adds some textobjects to the html.htmldjango filetype
"
"     idb/adb - in/around a django {% block %}
"     idf/adf - in around a django {% for %} loop
"     idi/adi - in/around a django {% if* } tag
"     idw/adw - in around a django {% with %} tag 
"
"    so Use as you would other text objects in visual selection, cutting and
"    dealleting etc.
"
" Installation:
"
"   Please ensure you have the above plugins installed as instructed
"   This file should be in your after/ftplugin for htmldjango
"
"   ~/.vim/after/ftplugin/htmldjango/template_textobjects.vim
"
" }}

if exists("loaded_matchit")
    let b:match_ignorecase = 1
    let b:match_skip = 's:Comment'
    let b:match_words = '<:>,' .
    \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
    \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
    \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,'  . 
    \ '{% *if .*%}:{% *else *%}:{% *endif *%},' . 
    \ '{% *ifequal .*%}:{% *else *%}:{% *endifequal *%},' . 
    \ '{% *ifnotequal .*%}:{% *else *%}:{% *endifnotequal *%},' . 
    \ '{% *ifchanged .*%}:{% *else *%}:{% *endifchanged *%},' . 
    \ '{% *for .*%}:{% *endfor *%},' . 
    \ '{% *with .*%}:{% *endwith *%},' .
    \ '{% *comment .*%}:{% *endcomment *%},' .
    \ '{% *block .*%}:{% *endblock *%},' .
    \ '{% *filter .*%}:{% *endfilter *%},' .
    \ '{% *spaceless .*%}:{% *endspaceless *%}' 
else
    finish
endif

if !exists('*g:textobj_function_htmldjango')

    fun s:select_a(type)
        let initpos = getpos(".")
        if  ( search('{% *'.a:type.' .*%}','b') == 0)
            return 0
        endif
        let e =getpos('.')
        normal g%f}
        let b = getpos('.')
        return ['v',b,e]
    endfun

    fun s:select_i(type)
        let initpos = getpos(".")
        if ( search('{% *'.a:type . " .*%}", 'b') == 0 )
            return 0
        endif
        normal f}
        "move one pesky char
        call search('.')
        let e =getpos('.')
        call search('{','b')
        normal g%
        "move one pesky char
        call search('.','b')
        let b = getpos('.')
        return ['v',b,e]
    endfun

    fun! g:textobj_function_htmldjango(block_type,object_type)
        return s:select_{a:block_type}_{a:object_type}()
    endfun

    fun s:select_block_a()
       return  s:select_a('block')
    endfun

    fun s:select_if_a()
       return s:select_a('if\(equal\|notequal\|changed\|\)')
    endfun

    fun s:select_with_a()
       return s:select_a('with')
    endfun

    fun s:select_comment_a()
       return s:select_a('comment')
    endfun


    fun s:select_for_a()
       return s:select_a('for')
    endfun

    fun s:select_block_i()
       return s:select_i('block')
    endfun

    fun s:select_if_i()
       return s:select_i('if\(equal\|notequal\|changed\|\)')
    endfun

    fun s:select_with_i()
       return s:select_i('with')
    endfun

    fun s:select_comment_i()
       return s:select_i('comment')
    endfun

    fun s:select_for_i()
       return s:select_i('for')
    endfun

endif

call textobj#user#plugin('djangotemplate',{
\   'block':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adb','*select-a-function*':'s:select_block_a',
\       'select-i':'idb', '*select-i-function*':'s:select_block_i'
\   },
\   'if':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adi','*select-a-function*':'s:select_if_a',
\       'select-i':'idi', '*select-i-function*':'s:select_if_i'
\   },
\   'with':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adw','*select-a-function*':'s:select_with_a',
\       'select-i':'idw', '*select-i-function*':'s:select_with_i'
\   },
\   'comment':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adc','*select-a-function*':'s:select_comment_a',
\       'select-i':'idc', '*select-i-function*':'s:select_comment_i'
\   },
\   'for':{
\       '*sfile*': expand('<sfile>:p'),
\       'select-a':'adf','*select-a-function*':'s:select_for_a',
\       'select-i':'idf', '*select-i-function*':'s:select_for_i'
\   },
\})
