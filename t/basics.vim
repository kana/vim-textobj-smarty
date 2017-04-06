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
    Expect Do('a', 16,  8) !=# ['V', 16,  1, 18, 14]
    Expect Do('a', 16,  9) ==# ['V', 16,  1, 18, 14]
    Expect Do('a', 17, 11) ==# ['V', 16,  1, 18, 14]
    Expect Do('a', 18, 13) ==# ['V', 16,  1, 18, 14]
    Expect Do('a', 19,  1) !=# ['V', 16,  1, 18, 14]

    Expect Do('i', 16,  8) !=# ['V', 17,  1, 17, 52]
    Expect Do('i', 16,  9) ==# ['V', 17,  1, 17, 52]
    Expect Do('i', 17, 11) ==# ['V', 17,  1, 17, 52]
    Expect Do('i', 18, 13) ==# ['V', 17,  1, 17, 52]
    Expect Do('i', 19,  1) !=# ['V', 17,  1, 17, 52]
  end

  it 'targets a right block from nested blocks'
    Expect Do('a', 14,  6) ==# ['V', 12,  1, 27, 10]
    Expect Do('a', 14,  7) ==# ['V', 14,  1, 25, 12]
    Expect Do('a', 16,  8) ==# ['V', 14,  1, 25, 12]
    Expect Do('a', 16,  9) ==# ['V', 16,  1, 18, 14]
    Expect Do('a', 19,  9) ==# ['V', 14,  1, 25, 12]
    Expect Do('a', 26,  7) ==# ['V', 12,  1, 27, 10]

    Expect Do('i', 14,  6) ==# ['V', 13,  1, 26, 48]
    Expect Do('i', 14,  7) ==# ['V', 15,  1, 24, 19]
    Expect Do('i', 16,  8) ==# ['V', 15,  1, 24, 19]
    Expect Do('i', 16,  9) ==# ['V', 17,  1, 17, 52]
    Expect Do('i', 19,  9) ==# ['V', 15,  1, 24, 19]
    Expect Do('i', 26,  7) ==# ['V', 13,  1, 26, 48]
  end

  it 'targets a {if} block with {else}'
    Expect Do('a', 29,  5) ==# ['V', 29,  1, 35, 10]
    Expect Do('a', 30,  5) ==# ['V', 29,  1, 35, 10]
    Expect Do('a', 31,  5) ==# ['V', 29,  1, 35, 10]
    Expect Do('a', 32,  5) ==# ['V', 29,  1, 35, 10]
    Expect Do('a', 33,  5) ==# ['V', 29,  1, 35, 10]
    Expect Do('a', 34,  5) ==# ['V', 29,  1, 35, 10]
    Expect Do('a', 35,  5) ==# ['V', 29,  1, 35, 10]

    Expect Do('i', 29,  5) ==# ['V', 30,  1, 34, 48]
    Expect Do('i', 30,  5) ==# ['V', 30,  1, 34, 48]
    Expect Do('i', 31,  5) ==# ['V', 30,  1, 34, 48]
    Expect Do('i', 32,  5) ==# ['V', 30,  1, 34, 48]
    Expect Do('i', 33,  5) ==# ['V', 30,  1, 34, 48]
    Expect Do('i', 34,  5) ==# ['V', 30,  1, 34, 48]
    Expect Do('i', 35,  5) ==# ['V', 30,  1, 34, 48]
  end

  it 'targets a {if} block with {else} and {elseif}'
    Expect Do('a', 37,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 38,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 39,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 40,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 41,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 42,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 43,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 44,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 45,  5) ==# ['V', 37,  1, 46, 10]
    Expect Do('a', 46,  5) ==# ['V', 37,  1, 46, 10]

    Expect Do('i', 37,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 38,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 39,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 40,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 41,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 42,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 43,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 44,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 45,  5) ==# ['V', 38,  1, 45, 48]
    Expect Do('i', 46,  5) ==# ['V', 38,  1, 45, 48]
  end

  it 'targets a {if} block with {else} and {elseif} and a single statement'
    Expect Do('a', 48,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 49,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 50,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 51,  5) ==# ['V', 50,  1, 52, 12]
    Expect Do('a', 52,  5) ==# ['V', 50,  1, 52, 12]
    Expect Do('a', 53,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 54,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 55,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 56,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 57,  5) ==# ['V', 56,  1, 58, 12]
    Expect Do('a', 58,  5) ==# ['V', 56,  1, 58, 12]
    Expect Do('a', 59,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 60,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 61,  5) ==# ['V', 60,  1, 62, 12]
    Expect Do('a', 62,  5) ==# ['V', 60,  1, 62, 12]
    Expect Do('a', 63,  5) ==# ['V', 48,  1, 64, 10]
    Expect Do('a', 64,  5) ==# ['V', 48,  1, 64, 10]

    Expect Do('i', 48,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 49,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 50,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 51,  5) ==# ['V', 51,  1, 51, 50]
    Expect Do('i', 52,  5) ==# ['V', 51,  1, 51, 50]
    Expect Do('i', 53,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 54,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 55,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 56,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 57,  5) ==# ['V', 57,  1, 57, 35]
    Expect Do('i', 58,  5) ==# ['V', 57,  1, 57, 35]
    Expect Do('i', 59,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 60,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 61,  5) ==# ['V', 61,  1, 61, 50]
    Expect Do('i', 62,  5) ==# ['V', 61,  1, 61, 50]
    Expect Do('i', 63,  5) ==# ['V', 49,  1, 63, 48]
    Expect Do('i', 64,  5) ==# ['V', 49,  1, 63, 48]
  end

  it 'does not have any side effect on registers'
    redir => original
    registers
    redir END

    call cursor(7, 11)
    normal vak

    redir => result
    registers
    redir END

    Expect result ==# original
  end

  it 'targets only {include}'
    Expect Do('a', 57, 12) ==# ['v', 57,  9, 57, 34]
    Expect Do('i', 57, 12) ==# ['v', 57,  9, 57, 34]
  end
end
