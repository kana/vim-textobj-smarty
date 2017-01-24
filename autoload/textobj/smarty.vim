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
  " Code example:
  "
  "     A
  "     {if X}
  "       B
  "       {if Y}
  "         C
  "       {/if}
  "       D
  "     {else}
  "       E
  "       {if Z1}
  "         F1
  "       {/if}
  "       F2
  "       {if Z2}
  "         F3
  "       {/if}
  "       G
  "     {/if}
  "     H
  "
  " ---------------------
  " cursor | expected | -
  " ---------------------
  " A      | -        | -
  " B      | X        | -
  " C      | Y        | -
  " D      | X        | -
  " E      | X        | -
  " F1     | Z1       | -
  " F2     | X        | -
  " F3     | Z2       | -
  " G      | X        | -
  " H      | -        | -
  " ---------------------
  return 0
endfunction




function! textobj#smarty#select_i()  "{{{2
  return 0
endfunction








" Misc.  "{{{1








" __END__  "{{{1
" vim: foldmethod=marker
