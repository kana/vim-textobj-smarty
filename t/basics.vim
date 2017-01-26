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

  it 'targets a {if} block with {else} and {elseif}'
    Expect Do('a', 37,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 38,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 39,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 40,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 41,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 42,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 43,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 44,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 45,  5) ==# ['v', 37,  5, 46,  9]
    Expect Do('a', 46,  5) ==# ['v', 37,  5, 46,  9]

    Expect Do('i', 37,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 38,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 39,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 40,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 41,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 42,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 43,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 44,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 45,  5) ==# ['v', 38,  1, 46,  4]
    Expect Do('i', 46,  5) ==# ['v', 38,  1, 46,  4]
  end

  it 'targets a {if} block with {else} and {elseif} and a single statement'
    Expect Do('a', 48,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 49,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 50,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 51,  5) ==# ['v', 50,  7, 52, 11]
    Expect Do('a', 52,  5) ==# ['v', 50,  7, 52, 11]
    Expect Do('a', 53,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 54,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 55,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 56,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 57,  5) ==# ['v', 56,  7, 58, 11]
    Expect Do('a', 58,  5) ==# ['v', 56,  7, 58, 11]
    Expect Do('a', 59,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 60,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 61,  5) ==# ['v', 60,  7, 62, 11]
    Expect Do('a', 62,  5) ==# ['v', 60,  7, 62, 11]
    Expect Do('a', 63,  5) ==# ['v', 48,  5, 64,  9]
    Expect Do('a', 64,  5) ==# ['v', 48,  5, 64,  9]

    Expect Do('i', 48,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 49,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 50,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 51,  5) ==# ['v', 51,  1, 52,  6]
    Expect Do('i', 52,  5) ==# ['v', 51,  1, 52,  6]
    Expect Do('i', 53,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 54,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 55,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 56,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 57,  5) ==# ['v', 57,  1, 58,  6]
    Expect Do('i', 58,  5) ==# ['v', 57,  1, 58,  6]
    Expect Do('i', 59,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 60,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 61,  5) ==# ['v', 61,  1, 62,  6]
    Expect Do('i', 62,  5) ==# ['v', 61,  1, 62,  6]
    Expect Do('i', 63,  5) ==# ['v', 49,  1, 64,  4]
    Expect Do('i', 64,  5) ==# ['v', 49,  1, 64,  4]
  end
end
