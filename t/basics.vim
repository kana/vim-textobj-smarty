filetype plugin indent on

function! GetLastSelection()
  return [visualmode(), line("'<"), col("'<"), line("'>"), col("'>")]
endfunction

describe 'vim-textobj-smarty'
  before
    tabnew t/fixtures/sample.tpl
  end

  after
    close!
  end

  it 'targets a one-liner block characterwise'
    /new/

    normal! vak
    Expect GetLastSelection() == ['v', 7, 7, 7, 36]

    normal! vik
    Expect GetLastSelection() == ['v', 7, 21, 7, 31]
  end
end
