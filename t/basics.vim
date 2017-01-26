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
end
