" textobj-smarty - Text objects for Smarty blocks
" Version: 0.0.0
" Copyright (C) 2017 Kana Natsuno <http://whileimautomaton.net/>
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
" }}}
" Interface  "{{{1
function! textobj#smarty#select_a()  "{{{2
  let head = s:search_head()
  if head[0] == 0 || head[1] == 0
    return 0
  endif
  let head_first = getpos('.')

  normal! l

  let tail = s:search_tail()
  if tail[0] == 0 || tail[1] == 0
    return 0
  endif

  normal! %
  let tail_last = getpos('.')

  return ['v', head_first, tail_last]
endfunction




function! textobj#smarty#select_i()  "{{{2
  let original_whichwrap = &whichwrap
  let &whichwrap = 'h,l'

  let result = s:select_i()

  let &whichwrap = original_whichwrap

  return result
endfunction

function! s:select_i()
  let head = s:search_head()
  if head[0] == 0 || head[1] == 0
    return 0
  endif

  normal! %l
  let inner_first = getpos('.')

  let tail = s:search_tail()
  if tail[0] == 0 || tail[1] == 0
    return 0
  endif

  normal! h
  let inner_last = getpos('.')

  return ['v', inner_first, inner_last]
endfunction








" Misc.  "{{{1
function! s:search_head()  "{{{2
  return searchpairpos('{\k\+\s\&\%({else\)\@!', '', '{/\k\+}\zs', 'bcW')
endfunction




function! s:search_tail()  "{{{2
  return searchpairpos('{\k\+\s\&\%({else\)\@!', '', '{/\k\+}', 'cW')
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
