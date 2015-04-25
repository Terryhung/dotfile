command! FZFLines call fzf#run({
      \ 'source':  BuffersLines(),
      \ 'sink':    function('LineHandler'),
      \ 'options': '--extended --nth=3..,',
      \ 'tmux_height': '60%'
      \})

function! LineHandler(l)
  let keys = split(a:l, ':\t')
  exec 'buf ' . keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! BuffersLines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

command! FZFMru call fzf#run({
      \'source': v:oldfiles,
      \'sink' : 'e ',
      \'options' : '-m',
      \ 'tmux_height': '60%'
      \})

nnoremap <leader>f :FZFLines<CR>
nnoremap <leader>o :FZF<CR>
nnoremap <leader>m :FZFMru<CR>
