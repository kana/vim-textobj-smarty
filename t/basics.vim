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
end
