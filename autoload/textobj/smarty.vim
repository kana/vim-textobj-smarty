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
  " TODO: Keep registers.
  let pos = getpos('.')

  " === Adjust the cursor to `{xxx}` or `{/xxx}` if necessary.

  let @0 = ''
  normal! yaB
  let token = @0
  let b = getpos("'[")
  let e = getpos("']")
  if !(token =~# '{.*}' && s:between(b, pos, e))
    call setpos('.', pos)
    " TODO: Implement.
    return 0
  endif

  " === Find the mate `{xxx}` or `{/xxx}` to `token`.

  let p1f = getpos('.')
  normal! %
  let p1l = getpos('.')
  normal! %lyl
  let is_head = @0 !=# '/'
  if is_head
    normal! yiw
  else
    normal! lyiw
  endif
  let raw_name = @0
  let name = s:normalize_mate_name(raw_name)

  " Adjust the cursor to `{if}` from `{else}` if necessary.
  if raw_name !=# name
    if s:search_mate(name, 0) == 0
      " `{else}` is written without `{if}` or `{/if}`.
      " This template seems to be broken.  Cancel the current selection.
      return 0
    endif
    let p1f = getpos('.')
    normal! %
    let p1l = getpos('.')
  endif

  let has_mate = s:search_mate(name, is_head) != 0
  if has_mate
    let p2f = getpos('.')
    normal! %
    let p2l = getpos('.')
    let head_first = is_head ? p1f : p2f
    let tail_last = is_head ? p2l : p1l
  else
    let head_first = p1f
    let tail_last = p1l
  endif

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
  if head < 1
    return 0
  endif

  normal! %l
  let inner_first = getpos('.')

  let tail = s:search_tail()
  if tail < 1
    return 0
  endif

  normal! h
  let inner_last = getpos('.')

  return ['v', inner_first, inner_last]
endfunction








" Misc.  "{{{1
function! s:between(b, p, e)  "{{{2
  return a:b[1] <= a:p[1] && a:p[1] <= a:e[1] &&
  \      a:b[2] <= a:p[2] && a:p[2] <= a:e[2]
endfunction




function! s:normalize_mate_name(name)  "{{{2
  return get(s:MATE_NAME_MAP, a:name, a:name)
endfunction

let s:MATE_NAME_MAP = {
\   'else': 'if',
\   'elseif': 'if',
\   'sectionelse': 'section',
\   'foreachelse': 'foreach',
\ }




function! s:search_mate(name, to_forward)  "{{{2
  if a:to_forward
    return searchpair('{' . a:name . '\>', '', '{/' . a:name . '}', 'cW')
  else
    return searchpair('{' . a:name . '\>', '', '{/' . a:name . '}\zs', 'bcW')
  endif
endfunction




function! s:search_head()  "{{{2
  return searchpair('{\k\+\s\&\%({else\)\@!', '', '{/\k\+}\zs', 'bcW')
endfunction




function! s:search_tail(...)  "{{{2
  if a:0 == 0
    return searchpair('{\k\+\s\&\%({else\)\@!', '', '{/\k\+}', 'cW')
  else
    return searchpair('{'.a:1.'\s', '', '{/'.a:1.'}', 'cW')
  endif
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
