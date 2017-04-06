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
  let result = s:select()
  if result is 0
    return 0
  endif

  return result[0]
endfunction




function! textobj#smarty#select_i()  "{{{2
  let original_whichwrap = &whichwrap
  let &whichwrap = 'h,l'

  let result = s:select_i()

  let &whichwrap = original_whichwrap
  return result
endfunction

function! s:select_i()
  let result = s:select()
  if result is 0
    return 0
  endif

  let [positions, has_mate] = result
  let [v, outer_first, outer_last] = positions
  if !has_mate
    return positions
  endif

  call setpos('.', outer_first)
  normal! %
  if v ==# 'V'
    normal! j
  else
    normal! l
  endif
  let inner_first = getpos('.')

  call setpos('.', outer_last)
  normal! %
  if v ==# 'V'
    normal! k
  else
    normal! h
  endif
  let inner_last = getpos('.')

  return [v, inner_first, inner_last]
endfunction








" Misc.  "{{{1
function! s:between(b, p, e)  "{{{2
  return (a:b[1] < a:p[1] || a:b[1] == a:p[1] && a:b[2] <= a:p[2])
  \   && (a:p[1] < a:e[1] || a:p[1] == a:e[1] && a:p[2] <= a:e[2])
endfunction




function! s:is_inlined(f, l)  "{{{2
  call setpos('.', a:f)
  let f = searchpos('^\s*\zs', 'bcnW')

  call setpos('.', a:l)
  let l = searchpos('\ze\s*$', 'cnW')

  return f != a:f[1:2] && l != a:l[1:2]
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




function! s:select()  "{{{2
  let [r0, r0t] = [@0, getregtype('0')]

  let result = s:_select()

  call setreg('0', r0, r0t)
  return result
endfunction

function! s:_select()
  let pos = getpos('.')

  " (1) Ensure that the cursor is located on {xxx} or {/xxx}.

  let @0 = ''
  silent! normal! yaB
  let token = @0
  let b = getpos("'[")
  let e = getpos("']")
  if !(token =~# '{.*}' && s:between(b, pos, e))
    " The cursor is located on neither {xxx} nor {/xxx},
    " but it might be located between {xxx} and {/xxx}.
    " Try moving the cursor to a proper {xxx}.
    call setpos('.', pos)
    while !0
      if search('{/\k\+}', 'W') == 0
        return 0
      endif
      let e = getpos('.')

      normal! llyiw
      if s:search_mate(@0, 0) == 0
        return 0
      endif
      let b = getpos('.')

      if s:between(b, pos, e)
        break
      endif
      call setpos('.', e)
    endwhile
  endif

  " (2) Check which of {xxx} and {/xxx} is under the cursor.

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

  " (3) Adjust the cursor to {if} if the cursor is located on {else}.

  if raw_name !=# name
    if s:search_mate(name, 0) == 0
      " {else} is written without {if} or {/if}.  This template is broken.
      return 0
    endif
    let p1f = getpos('.')
    normal! %
    let p1l = getpos('.')
  endif

  " (4) Select {single} or {block}-{/block}.

  let has_mate = s:search_mate(name, is_head) != 0
  if has_mate
    let p2f = getpos('.')
    normal! %
    let p2l = getpos('.')
    let head_first = is_head ? p1f : p2f
    let tail_last = is_head ? p2l : p1l
    let v = !s:is_inlined(p1f, p1l) && !s:is_inlined(p2f, p2l) ? 'V' : 'v'
  else
    if !is_head
      " {/xxx} is written without {xxx}.  This template is broken.
      return 0
    endif
    let head_first = p1f
    let tail_last = p1l
    let v = 'v'
  endif

  return [[v, head_first, tail_last], has_mate]
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
