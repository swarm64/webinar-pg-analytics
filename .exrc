let g:db="postgresql://postgres@localhost/etlsim"

hi clear WhitespaceEOL

set nowrap
set foldlevel=999
" set foldlevel=60

highlight clear ColorColumn
" let &colorcolumn=join(range(61,999),",")

nnoremap <C-Right> :bnext<CR>
nnoremap <C-Left> :bprevious<CR>

let g:limelight_default_coefficient = 0.7
let g:limelight_paragraph_span = 1
let g:limelight_bop = '^\s*$\n\zs'
let g:limelight_eop = '^\s*$'

" autocmd BufRead *.md Limelight
" autocmd BufRead *pro-tip*,*title*,*thank*,.exrc,*.dbout,*.sql Limelight!
