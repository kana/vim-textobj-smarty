filetype plugin indent on

function! GetLastSelection()
  return [visualmode(), line("'["), col("'["), line("']"), col("']")]
endfunction

function! Do(obj, line, col)
  call cursor(a:line, a:col)
  execute 'normal' 'y'.a:obj.'k'
  return GetLastSelection()
endfunction

describe 'vim-textobj-smarty'
  before
    tabnew t/fixtures/sample.tpl
  end

  after
    close!
  end

  it 'targets a one-liner block characterwise'
    Expect Do('a',  7,  6) !=# ['v',  7,  7,  7, 36]
    Expect Do('a',  7,  7) ==# ['v',  7,  7,  7, 36]
    Expect Do('a',  7,  9) ==# ['v',  7,  7,  7, 36]
    Expect Do('a',  7, 10) ==# ['v',  7,  7,  7, 36]
    Expect Do('a',  7, 11) ==# ['v',  7,  7,  7, 36]
    Expect Do('a',  7, 28) ==# ['v',  7,  7,  7, 36]
    Expect Do('a',  7, 31) ==# ['v',  7,  7,  7, 36]
    Expect Do('a',  7, 32) ==# ['v',  7,  7,  7, 36]
    Expect Do('a',  7, 36) ==# ['v',  7,  7,  7, 36]
    Expect Do('a',  7, 37) !=# ['v',  7,  7,  7, 36]

    Expect Do('i',  7,  6) !=# ['v',  7, 21,  7, 31]
    Expect Do('i',  7,  7) ==# ['v',  7, 21,  7, 31]
    Expect Do('i',  7,  9) ==# ['v',  7, 21,  7, 31]
    Expect Do('i',  7, 10) ==# ['v',  7, 21,  7, 31]
    Expect Do('i',  7, 11) ==# ['v',  7, 21,  7, 31]
    Expect Do('i',  7, 28) ==# ['v',  7, 21,  7, 31]
    Expect Do('i',  7, 31) ==# ['v',  7, 21,  7, 31]
    Expect Do('i',  7, 32) ==# ['v',  7, 21,  7, 31]
    Expect Do('i',  7, 36) ==# ['v',  7, 21,  7, 31]
    Expect Do('i',  7, 37) !=# ['v',  7, 21,  7, 31]
  end

  it 'targets a multi-line, innermost block characterwise'
    Expect Do('a', 16,  8) !=# ['v', 16,  9, 18, 13]
    Expect Do('a', 16,  9) ==# ['v', 16,  9, 18, 13]
    Expect Do('a', 17, 11) ==# ['v', 16,  9, 18, 13]
    Expect Do('a', 18, 13) ==# ['v', 16,  9, 18, 13]
    Expect Do('a', 19,  1) !=# ['v', 16,  9, 18, 13]

    Expect Do('i', 16,  8) !=# ['v', 17,  1, 18,  8]
    Expect Do('i', 16,  9) ==# ['v', 17,  1, 18,  8]
    Expect Do('i', 17, 11) ==# ['v', 17,  1, 18,  8]
    Expect Do('i', 18, 13) ==# ['v', 17,  1, 18,  8]
    Expect Do('i', 19,  1) !=# ['v', 17,  1, 18,  8]
  end

  it 'targets a right block from nested blocks'
    Expect Do('a', 14,  6) ==# ['v', 12,  5, 27,  9]
    Expect Do('a', 14,  7) ==# ['v', 14,  7, 25, 11]
    Expect Do('a', 16,  8) ==# ['v', 14,  7, 25, 11]
    Expect Do('a', 16,  9) ==# ['v', 16,  9, 18, 13]
    Expect Do('a', 19,  9) ==# ['v', 14,  7, 25, 11]
    Expect Do('a', 26,  7) ==# ['v', 12,  5, 27,  9]

    Expect Do('i', 14,  6) ==# ['v', 13,  1, 27,  4]
    Expect Do('i', 14,  7) ==# ['v', 15,  1, 25,  6]
    Expect Do('i', 16,  8) ==# ['v', 15,  1, 25,  6]
    Expect Do('i', 16,  9) ==# ['v', 17,  1, 18,  8]
    Expect Do('i', 19,  9) ==# ['v', 15,  1, 25,  6]
    Expect Do('i', 26,  7) ==# ['v', 13,  1, 27,  4]
  end

  it 'targets a {if} block with {else}'
    Expect Do('a', 29,  5) ==# ['v', 29,  5, 35,  9]
    Expect Do('a', 30,  5) ==# ['v', 29,  5, 35,  9]
    Expect Do('a', 31,  5) ==# ['v', 29,  5, 35,  9]
    Expect Do('a', 32,  5) ==# ['v', 29,  5, 35,  9]
    Expect Do('a', 33,  5) ==# ['v', 29,  5, 35,  9]
    Expect Do('a', 34,  5) ==# ['v', 29,  5, 35,  9]
    Expect Do('a', 35,  5) ==# ['v', 29,  5, 35,  9]

    Expect Do('i', 29,  5) ==# ['v', 30,  1, 35,  4]
    Expect Do('i', 30,  5) ==# ['v', 30,  1, 35,  4]
    Expect Do('i', 31,  5) ==# ['v', 30,  1, 35,  4]
    Expect Do('i', 32,  5) ==# ['v', 30,  1, 35,  4]
    Expect Do('i', 33,  5) ==# ['v', 30,  1, 35,  4]
    Expect Do('i', 34,  5) ==# ['v', 30,  1, 35,  4]
    Expect Do('i', 35,  5) ==# ['v', 30,  1, 35,  4]
  end
end
