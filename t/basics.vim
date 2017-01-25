filetype plugin indent on

function! GetLastSelection()
  return [visualmode(), line("'["), col("'["), line("']"), col("']")]
endfunction

describe 'vim-textobj-smarty'
  before
    tabnew t/fixtures/sample.tpl
  end

  after
    close!
  end

  it 'targets a one-liner block characterwise'
    normal! gg
    call search('new')

    normal yak
    Expect GetLastSelection() == ['v', 7, 7, 7, 36]

    normal yik
    Expect GetLastSelection() == ['v', 7, 21, 7, 31]
  end
end
